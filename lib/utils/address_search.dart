import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const kGoogleApiKey = "";

class AddressSearch extends StatefulWidget {
  final callback;
  String initialValue;
  bool isEditable;

  AddressSearch({Key? key, required this.callback, required this.isEditable, required this.initialValue}) : super(key: key);

  @override
  _AddressSearchState createState() => _AddressSearchState();
}

class _AddressSearchState extends State<AddressSearch> {
  final _controller = TextEditingController();
  bool _isVisibleListview = true;
  var uuid = Uuid();
  late final String _sessionToken = uuid.v4();
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
    _controller.text = widget.initialValue;
    _isVisibleListview = false;
  }

  _onChanged() {
    _isVisibleListview = true;
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    String kPLACESAPIKEY = kGoogleApiKey;
    // String type = '(regions)'; //TODO maybe add this to query
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACESAPIKEY&sessiontoken=$_sessionToken'; //TOdo if we want to filters cities only then add '&types=%28cities%29' to request
    final response = await http.get(Uri.parse(request), headers: {
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*",
    });
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditable) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Seek your location here",
                  focusColor: Colors.white,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.map),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      _controller.clear();
                      widget.callback(null);
                    },
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color: Colors.transparent, width: 3.0)),
                ),
                onSubmitted: (value) {
                  _isVisibleListview = false;
                },
              ),
            ),
            Visibility(
              visible: _isVisibleListview,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _placeList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_placeList[index]["description"]),
                    onTap: () {
                      _controller.text = _placeList[index]["description"];
                      widget.callback(_placeList[index]["description"]);
                      _isVisibleListview = false;
                    },
                  );
                },
              ),
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Text(
          widget.initialValue,
          style: TextStyle(color: Colors.grey, fontSize: 20),
        ),
      );
    }
  }
}
