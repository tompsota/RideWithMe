import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const kGoogleApiKey = "";

class AddressSearch extends StatefulWidget {
  AddressSearch({Key? key}) : super(key: key);

  @override
  _AddressSearchState createState() => _AddressSearchState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _AddressSearchState extends State<AddressSearch> {
  var _controller = TextEditingController();
  bool _is_visible_listview = true;
  var uuid = new Uuid();
  late String _sessionToken = uuid.v4();
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    _is_visible_listview = true;
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = kGoogleApiKey;
    String type = '(regions)';
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken'; //TOdo if we want to filters cities only then add '%28cities%29' to request
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
                  icon: Icon(Icons.cancel),
                  onPressed: () => _controller.clear(),
                ),
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color: Colors.transparent, width: 3.0)),
              ),
              onSubmitted: (value) {
                _is_visible_listview = false;
              },
            ),
          ),
          Visibility(
            visible: _is_visible_listview,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _placeList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_placeList[index]["description"]),
                  onTap: () {
                    _controller.text = _placeList[index]["description"];
                    _is_visible_listview = false;
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
