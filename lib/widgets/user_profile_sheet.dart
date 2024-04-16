import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/sheet_options.dart';
import 'package:music_player/providers/user_profile_provider.dart';
import 'package:music_player/screens/auth/auth.dart';
import 'package:music_player/widgets/space.dart';
import 'package:music_player/widgets/touchable_opacity.dart';
import 'package:provider/provider.dart';

class UserProfileSheet {
  static show(BuildContext context,
      {List<SheetOption> extraOptions = const []}) {
    UserProfileProvider userProfileProvider =
        Provider.of<UserProfileProvider>(context, listen: false);
    showModalBottomSheet(
      elevation: 0,
      context: context,
      backgroundColor: Colors.black,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.3),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                Space.v10,
                ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Text(
                      userProfileProvider.currentUser?.username[0] ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  title: Text(
                    userProfileProvider.currentUser?.username ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    userProfileProvider.currentUser?.email ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white.withOpacity(.3),
                  thickness: .5,
                ),
                for (var option in extraOptions)
                  TouchableOpacity(
                    onTap: () {
                      option.onTap();
                      Navigator.of(context).pop();
                    },
                    child: ListTile(
                      leading: Icon(
                        option.icon,
                        color: Colors.white,
                      ),
                      title: Text(
                        option.title,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                TouchableOpacity(
                  onTap: () async {
                    // logout and navigate to auth screen
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        AuthScreen.routeName, (route) => false);
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.power_settings_new,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Space.v(100),
              ],
            ),
          ),
        );
      },
    );
  }
}
