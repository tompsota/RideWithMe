import 'package:flutter/material.dart';

class CheckboxDialog extends StatefulWidget {
  const CheckboxDialog({Key? key}) : super(key: key);

  @override
  _CheckboxDialogState createState() => _CheckboxDialogState();
}

class _CheckboxDialogState extends State<CheckboxDialog> {
  bool checkboxValueCity = false;
  List<String> allCities = ['Coffee stop', 'Recovery ride', 'Chill ride', 'Race', 'Only roads', 'KOM hunting', 'Hills', 'Flat'];
  List<String> selectedCities = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: selectedCities.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(title: Text(selectedCities[index]));
                }),
          ),
          ElevatedButton(
              child: Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return DialogWindow(
                          cities: allCities,
                          selectedCities: selectedCities,
                          onSelectedCitiesListChanged: (cities) {
                            setState(
                              () => selectedCities = cities,
                            );
                          });
                    });
              }),
        ],
      ),
    );
  }
}

class DialogWindow extends StatefulWidget {
  DialogWindow({
    Key? key,
    required this.cities,
    required this.selectedCities,
    required this.onSelectedCitiesListChanged,
  }) : super(key: key);

  final List<String> cities;
  final List<String> selectedCities;
  final ValueChanged<List<String>> onSelectedCitiesListChanged;

  @override
  _DialogWindowState createState() => _DialogWindowState();
}

class _DialogWindowState extends State<DialogWindow> {
  List<String> _tempSelectedCities = [];

  @override
  void initState() {
    _tempSelectedCities = widget.selectedCities;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'TAGS',
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          //TODO make this smaller
          Flexible(
            child: ListView.builder(
                itemCount: widget.cities.length,
                itemBuilder: (BuildContext context, int index) {
                  final cityName = widget.cities[index];
                  return CheckboxListTile(
                      title: Text(cityName),
                      value: _tempSelectedCities.contains(cityName),
                      onChanged: (value) {
                        if (value == true) {
                          if (!_tempSelectedCities.contains(cityName)) {
                            setState(() {
                              _tempSelectedCities.add(cityName);
                            });
                          }
                        } else {
                          if (_tempSelectedCities.contains(cityName)) {
                            setState(() {
                              _tempSelectedCities.removeWhere((String city) => city == cityName);
                            });
                          }
                        }
                        widget.onSelectedCitiesListChanged(_tempSelectedCities);
                      });
                }),
          ),
          SizedBox(
            height: 40,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Done',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
