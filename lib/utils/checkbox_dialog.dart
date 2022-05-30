import 'package:flutter/material.dart';

class CheckboxDialog extends StatelessWidget {
  final bool isEditable;
  final ValueChanged<List<String>> callback;
  final List<String> selectedTags;
  final List<String> allTags = ['Coffee stop', 'Recovery ride', 'Chill ride', 'Race', 'Only roads', 'KOM hunting', 'Hills', 'Flat'];

  CheckboxDialog({Key? key, required this.isEditable, required this.callback, required this.selectedTags}) : super(key: key);

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
                itemCount: selectedTags.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(title: Text(selectedTags[index]));
                }),
          ),
          if (isEditable)
            ElevatedButton(
                child: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DialogWindow(
                            tags: allTags,
                            selectedTags: selectedTags,
                            onSelectedTagsListChanged: (tags) {
                              callback(selectedTags);
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
    required this.tags,
    required this.selectedTags,
    required this.onSelectedTagsListChanged,
  }) : super(key: key);

  final List<String> tags;
  final List<String> selectedTags;
  final ValueChanged<List<String>> onSelectedTagsListChanged;

  @override
  _DialogWindowState createState() => _DialogWindowState();
}

class _DialogWindowState extends State<DialogWindow> {
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
          Flexible(
            child: ListView.builder(
                itemCount: widget.tags.length,
                itemBuilder: (BuildContext context, int index) {
                  final cityName = widget.tags[index];
                  return CheckboxListTile(
                      title: Text(cityName),
                      value: widget.selectedTags.contains(cityName),
                      onChanged: (value) {
                        if (value == true) {
                          if (!widget.selectedTags.contains(cityName)) {
                            setState(() {
                              widget.selectedTags.add(cityName);
                            });
                          }
                        } else {
                          if (widget.selectedTags.contains(cityName)) {
                            setState(() {
                              widget.selectedTags.removeWhere((String city) => city == cityName);
                            });
                          }
                        }
                        widget.onSelectedTagsListChanged(widget.selectedTags);
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
