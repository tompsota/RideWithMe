import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/new_ride_controller.dart';
import '../utils/user_input_field.dart';

class RideMapComponent extends StatelessWidget {
  bool isBeingCreated;
  var linkController = TextEditingController();

  RideMapComponent({Key? key, required this.isBeingCreated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iframeWidth = MediaQuery.of(context).size.width.toInt() * 2.5; // some black magic
    final iframeHeight = MediaQuery.of(context).size.width.toInt() * 1.5;

    return Consumer<NewRideController>(builder: (context, newRideController, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: isBeingCreated
            ? UserInputField(
                callback: (link) => {newRideController.setRideMapLink(link)},
                controller: linkController,
              )
            : Container(
                child: kIsWeb
                    ? Image(
                        image: AssetImage("assets/abstract-map-placeholder.jpg"),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width * 0.54,
                        child: WebView(
                          initialUrl: Uri.dataFromString(
                                  '<html><body><iframe style="border:none" src="https://en.frame.mapy.cz/s/gozajafofo" width="$iframeWidth" height="$iframeHeight" frameborder="0"></iframe></body></html>',
                                  mimeType: 'text/html')
                              .toString(),
                          javascriptMode: JavascriptMode.unrestricted,
                        ),
                      ),
              ),
      );
    });
  }
}
