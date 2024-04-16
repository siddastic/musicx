import 'package:flutter_test/flutter_test.dart';
import 'package:music_player/constants/music_library.dart';

void main() {
  // Tests for Music Library
  test('Music Library should have unique IDs', () {
    var library = [...Music_Library];

    for (var i = 0; i < library.length; i++) {
      expect(library[i].id, i.toString(),
          reason: 'ID should be equal to index');
    }
  });
}
