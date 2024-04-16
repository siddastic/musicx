import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:music_player/models/sheet_options.dart';
import 'package:music_player/providers/current_music_provider.dart';
import 'package:music_player/providers/favourite_provider.dart';
import 'package:music_player/widgets/background_gradient.dart';
import 'package:music_player/widgets/music_options_sheet.dart';
import 'package:music_player/widgets/space.dart';
import 'package:provider/provider.dart';

class MusicPlayerScreen extends StatefulWidget {
  static const String routeName = "/tabs/music-player";
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  late StreamSubscription? positionSubscription;
  bool miniclipActive = false;

  @override
  void initState() {
    super.initState();
    CurrentMusicProvider currentMusicProvider =
        Provider.of<CurrentMusicProvider>(context, listen: false);
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    currentMusicProvider.player.playing
        ? controller.forward()
        : controller.reverse();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xff0E0E0E),
      ),
    );

    positionSubscription =
        currentMusicProvider.player.positionStream.listen((event) {
      // set play icon to pause icon when the song is finished
      if (event.inMilliseconds >=
          currentMusicProvider.duration!.inMilliseconds) {
        controller.reverse();
      }
    });
  }

  String formatDuration(Duration? duration) {
    if (duration == null) return "0:00";
    // Format the duration to mm:ss
    return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    CurrentMusicProvider currentMusicProvider =
        Provider.of<CurrentMusicProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: CachedNetworkImage(
              imageUrl: currentMusicProvider.currentPlaying!.coverImage,
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
          GestureDetector(
            onTap: () {
              setState(() {
                miniclipActive = !miniclipActive;
              });
            },
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: miniclipActive ? 1 : 0,
              child: CachedNetworkImage(
                imageUrl: currentMusicProvider.currentPlaying!.coverGif,
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: BackgroundGradient(
              layerOpacity: .65,
              primaryColor: currentMusicProvider.player.playing
                  ? currentMusicProvider.dominantColor
                  : null,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  Space.v(MediaQuery.of(context).padding.top + 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.keyboard_arrow_down_sharp),
                      ),
                      Column(
                        children: [
                          const Text(
                            "Playing from album",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            currentMusicProvider.currentPlaying!.album,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xffA34B4B),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          // Show options
                          MusicOptionsSheet.show(
                            context,
                            currentMusicProvider.currentPlaying!,
                            extraOptions: [
                              SheetOption(
                                title:
                                    "${miniclipActive ? "Hide" : "Show"} Miniclip",
                                icon: miniclipActive
                                    ? Icons.tv_off
                                    : Icons.tv_rounded,
                                onTap: () {
                                  setState(() {
                                    miniclipActive = !miniclipActive;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  Space.v(40),
                  Hero(
                    tag: currentMusicProvider.currentPlaying!.id,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: miniclipActive ? 0 : 1,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            miniclipActive = !miniclipActive;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(36),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: CachedNetworkImage(
                              imageUrl: currentMusicProvider
                                  .currentPlaying!.coverImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Space.v(32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 250),
                            opacity: miniclipActive ? 0 : 1,
                            child: Text(
                              currentMusicProvider.currentPlaying!.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          Space.v(8),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 250),
                            opacity: miniclipActive ? 0 : 1,
                            child: Text(
                              currentMusicProvider.currentPlaying!.artist,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.white.withOpacity(.3),
                              ),
                            ),
                          ),
                        ],
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 250),
                        opacity: miniclipActive ? 0 : 1,
                        child: Consumer<FavouriteProvider>(
                            builder: (context, provider, w) {
                          return IconButton(
                            onPressed: () {
                              provider.toggleFavourite(
                                  currentMusicProvider.currentPlaying!);
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: 1.seconds,
                                  content: Text(
                                    provider.isFavourite(currentMusicProvider
                                            .currentPlaying!)
                                        ? "Added to Liked Songs"
                                        : "Removed from Liked Songs",
                                  ),
                                ),
                              );
                            },
                            icon: Icon(provider.isFavourite(
                                    currentMusicProvider.currentPlaying!)
                                ? Icons.favorite
                                : Icons.favorite_border),
                          );
                        }),
                      )
                    ],
                  ),
                  Space.v(55),
                  StreamBuilder(
                    stream: currentMusicProvider.player.positionStream,
                    builder: (context, snapshot) {
                      return SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 2,
                          thumbShape: SliderComponentShape.noThumb,
                          trackShape: SliderCustomTrackShape(),
                        ),
                        child: Slider(
                          max: currentMusicProvider.duration?.inSeconds
                                  .toDouble() ??
                              0.0,
                          value: snapshot.hasData
                              ? clampDouble(
                                  snapshot.data?.inSeconds.toDouble() ?? 0,
                                  0,
                                  currentMusicProvider.duration?.inSeconds
                                          .toDouble() ??
                                      1)
                              : 0.0,
                          onChanged: (value) {
                            currentMusicProvider.player
                                .seek(Duration(seconds: value.toInt()));
                          },
                          activeColor: Colors.white,
                          inactiveColor: const Color(0xffA34B4B),
                        ),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder(
                        stream: currentMusicProvider.player.positionStream,
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.hasData
                                ? formatDuration(snapshot.data)
                                : "0:00",
                            style: TextStyle(
                              color: Colors.white.withOpacity(.3),
                            ),
                          );
                        },
                      ),
                      Text(
                        formatDuration(currentMusicProvider.duration),
                        style: TextStyle(
                          color: Colors.white.withOpacity(.3),
                        ),
                      ),
                    ],
                  ),
                  Space.v(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        padding: const EdgeInsets.all(16),
                        onPressed: () {
                          animation.isDismissed
                              ? controller.forward()
                              : controller.reverse();
                          currentMusicProvider.player.playing
                              ? currentMusicProvider.pause()
                              : currentMusicProvider.play();
                        },
                        icon: AnimatedIcon(
                          icon: AnimatedIcons.play_pause,
                          progress: animation,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    positionSubscription?.cancel();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
      ),
    );
    super.dispose();
  }
}

class SliderCustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
