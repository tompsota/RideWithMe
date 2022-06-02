
import 'package:flutter/material.dart';
import 'package:ride_with_me/components/ride/rides_list_view.dart';

import '../../domain_layer/models/ride_model.dart';

// TODO: probably rename to something better
class RidesStreamBuilder extends StatelessWidget {

  final Stream<List<RideModel>> ridesStream;

  RidesStreamBuilder({Key? key, required this.ridesStream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RideModel>>(
      stream: ridesStream,
      builder: (BuildContext context, AsyncSnapshot<List<RideModel>> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong!'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text("Loading rides ..."));
        }

        if (!snapshot.hasData || snapshot.data?.length == 0) {
          return Center(child: Text("No rides to show."));
        }

        return RidesListView(rides: snapshot.data);
      },
    );
  }

}