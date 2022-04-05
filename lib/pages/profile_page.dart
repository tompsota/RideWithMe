import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/controllers/user_state_controller.dart';

import '../models/user_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final userModel = Provider.of<CustomUserModel>(context);
    return Consumer<UserStateController>(
      builder: (context, user, child) {
        return Column(
          children: [
            Text('First name: ${user.customUser?.firstName}'),
            Text('Last name: ${user.customUser?.lastName}'),
            Text('User: ${user.user?.email}'),
            Text('About me: ${user.customUser?.aboutMe}'),
            Image.network(user.user?.photoURL ?? 'https://upload.wikimedia.org/wikipedia/commons/c/c4/Orange-Fruit-Pieces.jpg'),
          ],
        );
      },
    );
  }
}