import 'package:flutter/material.dart';
import 'package:ride_with_me/utils/ride/ride_list_tile.dart';

import '../../domain_layer/models/ride_model.dart';
import '../../domain_layer/models/user_model.dart';

class RideParticipantsIcons extends StatelessWidget {

  final List<UserModel>? participants;

  RideParticipantsIcons({Key? key, required this.participants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (participants == null) {
      return Stack(
        children: [
          ...List.generate(
            12,
                (index) => Positioned(
              left: index * 12,
              child: CircleAvatar(
                // TODO: change background image to just plain (e.g. black / navy blue / ...) circle ?
                backgroundImage: index.isEven
                    ? NetworkImage(
                    'https://upload.wikimedia.org/wikipedia/commons/c/c4/Orange-Fruit-Pieces.jpg')
                    : NetworkImage(
                    'https://portswigger.net/cms/images/63/12/0c8b-article-211117-linux-rng.jpg'),
                maxRadius: 12,
              ),
            ),
          ),
        ],
      );
    }

    return Stack(
      children:
      List.generate(
        participants!.length,
            (index) => Positioned(
              left: index * 12,
              child: CircleAvatar(
            backgroundImage: NetworkImage(participants![index].avatarUrl),
            maxRadius: 12,
          ),
        ),
      ),
    );
  }
}

