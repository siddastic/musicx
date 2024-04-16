import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/musicx_user.dart';

class UserProfileProvider extends ChangeNotifier {
  MusicxUser? _user;
  bool _loaded = false;

  MusicxUser? get currentUser => _user;
  bool get loaded => _loaded;

  void loadUser() async {
    var snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (snap.exists) {
      _user = MusicxUser.fromJson(snap.data() as Map<String, dynamic>);
      _loaded = true;
      notifyListeners();
    }
  }
}
