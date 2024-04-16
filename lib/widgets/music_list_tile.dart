import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/music.dart';
import 'package:music_player/providers/current_music_provider.dart';
import 'package:music_player/providers/favourite_provider.dart';
import 'package:music_player/screens/tabs/subscreens/music_player.dart';
import 'package:music_player/widgets/music_options_sheet.dart';
import 'package:music_player/widgets/visualizer.dart';
import 'package:provider/provider.dart';

class MusicListTile extends StatelessWidget {
  final Music music;
  const MusicListTile({super.key, required this.music});

  @override
  Widget build(BuildContext context) {
    CurrentMusicProvider currentMusicProvider =
        Provider.of<CurrentMusicProvider>(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      onTap: () {
        if (currentMusicProvider.currentPlaying?.id != music.id) {
          currentMusicProvider.setCurrentPlaying(music);
          currentMusicProvider.player.play();
        }
        Navigator.of(context).pushNamed(MusicPlayerScreen.routeName);
      },
      onLongPress: () {
        MusicOptionsSheet.show(context, music);
      },
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Hero(
          tag: music.id,
          child: CachedNetworkImage(
            imageUrl: music.coverImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        music.title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: currentMusicProvider.currentPlaying?.id == music.id
              ? const Color(0xffA34B4B)
              : Colors.white,
        ),
      ),
      subtitle: Text(
        "${music.artist} • ${music.album}",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: Colors.white.withOpacity(.3),
        ),
      ),
      trailing: currentMusicProvider.currentPlaying?.id == music.id
          ? SizedBox(
              height: 26,
              width: 36,
              child: Visualizer(
                primaryColor: currentMusicProvider.dominantColor ??
                    Theme.of(context).primaryColor,
                amplitude: 1,
              ),
            )
          : Consumer<FavouriteProvider>(builder: (context, provider, w) {
              return IconButton(
                onPressed: () {
                  provider.toggleFavourite(music);
                },
                iconSize: 20,
                icon: Icon(
                  provider.isFavourite(music)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: provider.isFavourite(music)
                      ? Colors.white
                      : Colors.white.withOpacity(.3),
                ),
              );
            }),
    );
  }
}
