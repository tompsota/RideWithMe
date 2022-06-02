import 'package:flutter/material.dart';
import 'package:ride_with_me/utils/ride/ride_list_tile.dart';

import '../../domain_layer/models/ride_model.dart';

class RidesListView extends StatelessWidget {

  final List<RideModel>? rides;

  RidesListView({Key? key, required this.rides}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rides == null) {
      return Text('No rides to show.');
    }

    return ListView(
        shrinkWrap: true,
        children: rides!.map((ride) => RideListTile(ride: ride)).toList(),
    );
  }
}

