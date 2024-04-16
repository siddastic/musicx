import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/providers/current_music_provider.dart';
import 'package:music_player/providers/favourite_provider.dart';
import 'package:music_player/providers/user_profile_provider.dart';
import 'package:music_player/screens/tabs/favourites.dart';
import 'package:music_player/screens/tabs/home.dart';
import 'package:music_player/screens/tabs/subscreens/music_player.dart';
import 'package:music_player/widgets/space.dart';
import 'package:provider/provider.dart';

class TabScreen extends StatefulWidget {
  static const String routeName = "/tabs";
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
      ),
    );
    loadUserData();
  }

  void loadUserData() {
    Provider.of<UserProfileProvider>(context, listen: false).loadUser();
    Provider.of<FavouriteProvider>(context, listen: false).loadFavorites();
  }

  void changeTab(int index) {
    setState(() {
      _currentPage = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              HomeScreen(
                changeTab: changeTab,
              ),
              const FavouriteScreen(),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Column(
              children: [
                OpenContainer(
                  closedColor: Colors.transparent,
                  closedElevation: 0,
                  closedBuilder: (context, action) {
                    return Consumer<CurrentMusicProvider>(
                      builder: (context, value, child) {
                        if (value.currentPlaying == null) {
                          return const SizedBox();
                        }
                        Color? calculatedBackgroundColor;
                        if (value.player.playing &&
                            value.dominantColor != null &&
                            value.dominantColor!.computeLuminance() < 0.179) {
                          calculatedBackgroundColor = value.dominantColor;
                        } else {
                          calculatedBackgroundColor =
                              Theme.of(context).primaryColor;
                        }
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          width: MediaQuery.of(context).size.width - 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: calculatedBackgroundColor,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    calculatedBackgroundColor!.withOpacity(.5),
                                blurRadius: 20,
                                spreadRadius: .5,
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 6),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            value.currentPlaying!.coverImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Space.h10,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          value.currentPlaying!.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          value.currentPlaying!.artist,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: Colors.white.withOpacity(.3),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    StatefulBuilder(
                                      builder: (context, setter) {
                                        return IconButton(
                                          onPressed: () {
                                            if (value.player.playing) {
                                              value.pause();
                                            } else {
                                              value.play();
                                            }
                                            setter(() {});
                                          },
                                          icon: value.player.playing
                                              ? const Icon(Icons.pause)
                                              : const Icon(Icons.play_arrow),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              StreamBuilder(
                                stream: value.player.positionStream,
                                builder: (context, snapshot) {
                                  return LinearProgressIndicator(
                                    minHeight: 2,
                                    value: value.player.position.inSeconds
                                            .toDouble() /
                                        (value.player.duration?.inSeconds ?? 1)
                                            .toDouble(),
                                    backgroundColor:
                                        Colors.white.withOpacity(.5),
                                    valueColor: const AlwaysStoppedAnimation(
                                        Colors.white),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  openBuilder: (context, action) {
                    return const MusicPlayerScreen();
                  },
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.4, 0.7],
                      colors: [
                        Colors.transparent,
                        Colors.black,
                      ],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: BottomNavigationBar(
                    selectedItemColor: Colors.white,
                    unselectedItemColor:
                        const Color(0xffA34B4B).withOpacity(.75),
                    backgroundColor: Colors.transparent,
                    currentIndex: _currentPage,
                    onTap: (index) {
                      setState(() {
                        _currentPage = index;
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      });
                    },
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: "Home",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: "Favourites",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
