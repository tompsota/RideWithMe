import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/controllers/user_state_controller.dart';

import '../../controllers/new_ride_controller.dart';
import '../../domain_layer/models/ride_model.dart';
import '../../domain_layer/models/user_model.dart';
import '../../utils/text.dart';

class RideAuthorImage extends StatelessWidget {
  final UserModel? author;
  final String authorName;

  RideAuthorImage({Key? key, required this.author, required this.authorName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NewRideController>(builder: (context, newRideController, _) {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              backgroundImage:
                  NetworkImage(author?.avatarUrl ?? 'https://upload.wikimedia.org/wikipedia/commons/c/c4/Orange-Fruit-Pieces.jpg'),
              maxRadius: 30,
            ),
          ),
          LargeText("by $authorName"),
        ],
      );
    });
  }
}
