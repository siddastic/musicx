import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_player/models/music.dart';
import 'package:music_player/models/sheet_options.dart';
import 'package:music_player/providers/favourite_provider.dart';
import 'package:music_player/widgets/music_list_tile.dart';
import 'package:music_player/widgets/space.dart';
import 'package:music_player/widgets/touchable_opacity.dart';
import 'package:provider/provider.dart';

class MusicOptionsSheet {
  static show(BuildContext context, Music music,
      {List<SheetOption> extraOptions = const []}) {
    FavouriteProvider favouriteProvider =
        Provider.of<FavouriteProvider>(context, listen: false);
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
                IgnorePointer(child: MusicListTile(music: music)),
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
                  onTap: () {
                    favouriteProvider.toggleFavourite(music);
                    Navigator.of(context).pop();
                  },
                  child: ListTile(
                    leading: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                    ),
                    title: Text(
                      "${favouriteProvider.isFavourite(music) ? "Remove from" : "Add to"} Liked Songs",
                      style: const TextStyle(
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
