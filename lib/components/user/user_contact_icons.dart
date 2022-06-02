import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../domain_layer/models/user_model.dart';
import '../../utils/ride_icon_button.dart';

class UserContactIcons extends StatelessWidget {
  final UserModel user;

  const UserContactIcons({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (user.facebookAccount.isNotEmpty)
            RideIconButton(icon: FontAwesomeIcons.facebook, accountLink: 'facebook.com/' + user.facebookAccount, serviceName: 'Facebook'),
          if (user.stravaAccount.isNotEmpty)
            RideIconButton(icon: FontAwesomeIcons.strava, accountLink: 'strava.com/' + user.stravaAccount, serviceName: 'Strava'),
          if (user.instagramAccount.isNotEmpty)
            RideIconButton(
                icon: FontAwesomeIcons.instagram, accountLink: 'instagram.com/' + user.instagramAccount, serviceName: 'Instagram'),
          if (user.googleAccount.isNotEmpty)
            RideIconButton(icon: FontAwesomeIcons.google, accountLink: 'google.com/' + user.googleAccount, serviceName: 'Google'),
          if (user.slackAccount.isNotEmpty)
            RideIconButton(icon: FontAwesomeIcons.slack, accountLink: 'slack.com/' + user.slackAccount, serviceName: 'Slack'),
          if (user.email.isNotEmpty) RideIconButton(icon: FontAwesomeIcons.envelope, accountLink: user.email, serviceName: 'Email'),
        ],
      ),
    );
  }
}
