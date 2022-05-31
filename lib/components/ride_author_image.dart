import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/new_ride_controller.dart';
import '../models/ride_model.dart';
import '../utils/text.dart';

class RideAuthorImage extends StatelessWidget {
  RideModel? ride;
  String authorName;

  RideAuthorImage({Key? key, required this.ride, required this.authorName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NewRideController>(builder: (context, newRideController, _) {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              backgroundImage:
                  NetworkImage(ride?.author?.avatarUrl ?? 'https://upload.wikimedia.org/wikipedia/commons/c/c4/Orange-Fruit-Pieces.jpg'),
              maxRadius: 30,
            ),
          ),
          LargeText("by $authorName"),
        ],
      );
    });
  }
}
