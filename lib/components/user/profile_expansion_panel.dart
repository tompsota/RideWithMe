import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../controllers/user_state_controller.dart';
import '../../domain_layer/repositories/db_repository.dart';
import '../../domain_layer/filters.dart';
import '../../domain_layer/models/user_model.dart';
import '../ride/rides_stream_builder.dart';
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

    final ridesRepository = Provider.of<DbRepository>(context, listen: false).ridesRepository;
    final ridesData = [
      Tuple2<String, List<String>>('Completed rides', widget.user.completedRidesIds),
      Tuple2<String, List<String>>('Created rides', widget.user.createdRidesIds),
      Tuple2<String, List<String>>('Joined rides', widget.user.joinedRidesIds),
    ];

    return ExpansionPanelList(
      children: ridesData.mapIndexed((i, data) {
        final String headerTitle = data.item1;
        final ridesIds = data.item2;
        return ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: MediumText(headerTitle),
            );
          },
          body: RidesStreamBuilder(ridesStream: ridesRepository.getRidesFromCollection(ridesIds)),
          isExpanded: _isExpanded[i],
          canTapOnHeader: true,
        );
      }).toList(),
      expansionCallback: (i, isExpanded) => setState(() => _isExpanded[i] = !isExpanded),
    );
  }
}
