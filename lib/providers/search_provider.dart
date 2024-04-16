import 'package:flutter/material.dart';
import 'package:music_player/constants/music_library.dart';
import 'package:music_player/models/music.dart';

class SearchProvider extends ChangeNotifier {
  String _query = "";
  String get query => _query;

  void setQuery(String query) {
    _query = query;
    notifyListeners();
  }

  List<Music> get searchResults {
    if (_query.isEmpty) {
      return Music_Library;
    }
    return Music_Library.where(
        (m) => m.title.toLowerCase().contains(_query.toLowerCase())).toList();
  }

  List<Music> get searchResultsByArtist {
    return Music_Library.where(
        (m) => m.artist.toLowerCase().contains(_query.toLowerCase())).toList();
  }

  List<Music> get searchResultsByAlbum {
    return Music_Library.where(
        (m) => m.album.toLowerCase().contains(_query.toLowerCase())).toList();
  }
}
