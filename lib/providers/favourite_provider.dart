import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:music_player/constants/music_library.dart';
import 'package:music_player/models/music.dart';

class FavouriteProvider with ChangeNotifier {
  bool _isLoading = true;
  final List<Music> _favourites = [];

  bool get isLoading => _isLoading;
  List<Music> get favourites => _favourites;

  void loadFavorites() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      for (var doc in querySnapshot.docs) {
        for (var music in Music_Library) {
          if (music.id == doc.id) {
            _favourites.add(music);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  void addFavourite(Music music) {
    _favourites.add(music);
    notifyListeners();
    // add to firebase in background
    try {
      FirebaseFirestore.instance.collection('users').doc(music.id).set({
        "fav": true,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void removeFavourite(Music music) {
    _favourites.remove(music);
    notifyListeners();
    // remove from firebase in background
    try {
      FirebaseFirestore.instance.collection('users').doc(music.id).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void toggleFavourite(Music music) {
    if (isFavourite(music)) {
      removeFavourite(music);
    } else {
      addFavourite(music);
    }
  }

  bool isFavourite(Music music) {
    return _favourites.where((element) => element.id == music.id).isNotEmpty;
  }
}
