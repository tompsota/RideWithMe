import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../controllers/user_state_controller.dart';
import '../domain_layer/db_repository.dart';
import '../utils/filters.dart';
import '../utils/ride/rides_stream_builder.dart';
import '../utils/text.dart';

class ProfileExpansionPanel extends StatefulWidget {
  const ProfileExpansionPanel({Key? key}) : super(key: key);

  @override
  _ProfileExpansionPanelState createState() => _ProfileExpansionPanelState();
}

class _ProfileExpansionPanelState extends State<ProfileExpansionPanel> {
  @override
  Widget build(BuildContext context) {
    final dbRepository = Provider.of<DbRepository>(context, listen: false);
    final ridesRepository = dbRepository.ridesRepository;
    return Consumer<UserStateController>(builder: (context, userController, child) {
      final user = userController.user;
      return ExpansionPanelList(
        children: [
          Tuple2<String, List<String>>('Completed rides', user.completedRidesIds),
          Tuple2<String, List<String>>('Created rides', user.createdRidesIds),
          Tuple2<String, List<String>>('Joined rides', user.joinedRidesIds),
        ].map((data) {
          final String headerTitle = data.item1;
          final ridesIds = data.item2;
          return ExpansionPanel(
            headerBuilder: (context, isExpanded) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: MediumText(headerTitle),
              );
            },
            body: RidesStreamBuilder(ridesStream: ridesRepository.getFullRides(Filters.isRideFromCollection(ridesIds))),
            isExpanded: true,
            canTapOnHeader: true,
          );
        }).toList(),
      );
    });
  }
}
