import 'package:flutter/material.dart';
import 'package:music_player/constants/music_library.dart';
import 'package:music_player/models/music.dart';
import 'package:music_player/providers/search_provider.dart';
import 'package:music_player/widgets/music_list_tile.dart';
import 'package:provider/provider.dart';

enum SearchBy {
  Song,
  Artist,
  Album,
}

class SearchResults extends StatefulWidget {
  const SearchResults({super.key});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  SearchBy searchBy = SearchBy.Song;
  @override
  Widget build(BuildContext context) {
    SearchProvider searchProvider = Provider.of<SearchProvider>(context);
    if (searchProvider.query.isEmpty) {
      return Column(
        children: [
          for (var m in Music_Library)
            MusicListTile(
              music: m,
            )
        ],
      );
    }
    List<Music> searchResults = [];
    switch (searchBy) {
      case SearchBy.Song:
        searchResults = searchProvider.searchResults;
        break;
      case SearchBy.Artist:
        searchResults = searchProvider.searchResultsByArtist;
        break;
      case SearchBy.Album:
        searchResults = searchProvider.searchResultsByAlbum;
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              for (SearchBy s in SearchBy.values)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  margin: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
                  decoration: BoxDecoration(
                    color: s == searchBy ? Colors.green : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: s == searchBy
                          ? Colors.green
                          : Colors.white.withOpacity(.5),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        searchBy = s;
                      });
                    },
                    child: Text(
                      s.toString().split('.').last,
                      style: TextStyle(
                        fontSize: 14,
                        color: s == searchBy
                            ? Colors.white
                            : Colors.white.withOpacity(.5),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "Showing ${searchResults.length} results for \"${searchProvider.query}\"",
            style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(.5)),
          ),
        ),
        for (var m in searchResults)
          MusicListTile(
            music: m,
          )
      ],
    );
  }
}
