import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:music_player/providers/current_music_provider.dart';
import 'package:music_player/providers/favourite_provider.dart';
import 'package:music_player/widgets/background_gradient.dart';
import 'package:music_player/widgets/music_list_tile.dart';
import 'package:music_player/widgets/space.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CurrentMusicProvider currentMusicProvider =
        Provider.of<CurrentMusicProvider>(context);
    FavouriteProvider favouriteProvider =
        Provider.of<FavouriteProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Image.asset(
              "assets/images/heart.png",
              fit: BoxFit.contain,
              height: 300,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          ClipRRect(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(.5),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: BackgroundGradient(
              layerOpacity: .65,
              child: favouriteProvider.isLoading
                  ? const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : ListView(
                      padding: const EdgeInsets.only(top: 60),
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            "Liked Songs",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (favouriteProvider.favourites.isEmpty) ...[
                          Lottie.asset(
                            "assets/anim/music_fly.json",
                            height: 300,
                            width: 400,
                          ),
                          Space.v20,
                          Center(
                            child: Text(
                              "Like some songs\nto see them here!",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(.5),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ] else ...[
                          Space.v20,
                          for (var m in favouriteProvider.favourites)
                            Dismissible(
                              direction: DismissDirection.startToEnd,
                              background: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 20),
                                child:
                                    const Icon(Icons.delete, color: Colors.red),
                              ),
                              key: ValueKey(m.id),
                              onDismissed: (direction) {
                                favouriteProvider.toggleFavourite(m);
                              },
                              child: MusicListTile(
                                music: m,
                              ),
                            ),
                          Space.v(150),
                        ],
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
