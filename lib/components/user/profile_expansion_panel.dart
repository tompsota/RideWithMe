import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ride_with_me/components/ride/rides_list_view.dart';
import 'package:tuple/tuple.dart';

import '../../domain_layer/models/ride_model.dart';
import '../../domain_layer/models/user_model.dart';
import '../../utils/text.dart';


class ProfileExpansionPanel extends StatefulWidget {
  final UserModel user;
  ProfileExpansionPanel({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileExpansionPanelState createState() => _ProfileExpansionPanelState();
}

class _ProfileExpansionPanelState extends State<ProfileExpansionPanel> {

  List<bool> _isExpanded = List.filled(3, false);

  @override
  Widget build(BuildContext context) {

    final ridesData = [
      Tuple2<String, List<RideModel>>('Joined rides', widget.user.joinedRides),
      Tuple2<String, List<RideModel>>('Created rides', widget.user.createdRides),
      Tuple2<String, List<RideModel>>('Completed rides', widget.user.completedRides),
    ];

    return ExpansionPanelList(
      children: ridesData.mapIndexed((i, data) {
        final headerTitle = data.item1;
        final rides = data.item2;
        return ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: MediumText(headerTitle),
            );
          },
          body: RidesListView(rides: rides),
          isExpanded: _isExpanded[i],
          canTapOnHeader: true,
        );
      }).toList(),
      expansionCallback: (i, isExpanded) => setState(() => _isExpanded[i] = !isExpanded),
    );
  }
}
