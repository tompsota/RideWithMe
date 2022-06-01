import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/new_ride_controller.dart';
import '../utils/title_button.dart';

class RideTitleBar extends StatelessWidget {
  const RideTitleBar({
    Key? key,
    required this.isBeingCreated,
    required this.titleController,
  }) : super(key: key);

  final bool isBeingCreated;
  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return Consumer<NewRideController>(builder: (context, newRideController, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: TitleButton(
            isEnabled: isBeingCreated,
            callback: (title) {
              newRideController.setRideTitle(title);
            },
            textController: titleController,
          )),
          IconButton(
            icon: Icon(Icons.close, color: Theme.of(context).unselectedWidgetColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    });
  }
}
