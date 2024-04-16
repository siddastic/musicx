import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_player/models/sheet_options.dart';
import 'package:music_player/providers/search_provider.dart';
import 'package:music_player/providers/user_profile_provider.dart';
import 'package:music_player/widgets/background_gradient.dart';
import 'package:music_player/widgets/search_results.dart';
import 'package:music_player/widgets/space.dart';
import 'package:music_player/widgets/user_profile_sheet.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int tab) changeTab;
  const HomeScreen({super.key, required this.changeTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSearchActive = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(.5),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: BackgroundGradient(
              layerOpacity: .65,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: MediaQuery.of(context).padding.top,
                    color: isSearchActive ? Colors.black : Colors.transparent,
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: SizedBox(
                      height: isSearchActive ? 0 : 70,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Musicx",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Consumer<UserProfileProvider>(
                                builder: (context, provider, w) {
                              return IconButton(
                                icon: CircleAvatar(
                                  radius: 16,
                                  child: Text(
                                    provider.loaded
                                        ? provider.currentUser!.username[0]
                                            .toUpperCase()
                                        : "",
                                  ),
                                ),
                                onPressed: () {
                                  UserProfileSheet.show(context, extraOptions: [
                                    SheetOption(
                                      title: "Liked Songs",
                                      icon: Icons.favorite,
                                      onTap: () {
                                        widget.changeTab(1);
                                      },
                                    ),
                                  ]);
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(
                        horizontal: isSearchActive ? 0 : 24),
                    decoration: BoxDecoration(
                      color: isSearchActive ? Colors.black : Colors.white,
                      borderRadius:
                          BorderRadius.circular(isSearchActive ? 0 : 12),
                    ),
                    child: Consumer<SearchProvider>(
                        builder: (context, provider, w) {
                      return Focus(
                        onFocusChange: (value) {
                          setState(() {
                            isSearchActive = value || provider.query.isNotEmpty;
                          });
                        },
                        child: TextField(
                          textInputAction: TextInputAction.search,
                          style: TextStyle(
                            color: isSearchActive ? Colors.white : Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: "Search for songs...",
                            hintStyle: TextStyle(
                              color:
                                  isSearchActive ? Colors.white : Colors.black,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color:
                                  isSearchActive ? Colors.white : Colors.black,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                          ),
                          onChanged: (value) {
                            provider.setQuery(value.trim());
                          },
                        ),
                      );
                    }),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: isSearchActive ? 0 : 20,
                  ),
                  const SearchResults(),
                  Space.v(150),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
