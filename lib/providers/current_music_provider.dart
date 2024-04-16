import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/models/music.dart';
import 'package:palette_generator/palette_generator.dart';

class CurrentMusicProvider extends ChangeNotifier {
  final player = AudioPlayer();
  Music? _currentPlaying;
  Duration? _duration;
  Color? _dominantColor;

  Music? get currentPlaying => _currentPlaying;
  Duration? get duration => _duration;
  Color? get dominantColor => _dominantColor;

  void setCurrentPlaying(Music music) async {
    _dominantColor = null;
    _currentPlaying = music;
    _duration = await player.setUrl(music.path);
    _dominantColor = await getImagePalette();
    player.positionStream.listen((event) {
      // stop the player if the song is finished
      if (event.inMilliseconds >= _duration!.inMilliseconds) {
        player.seek(null);
        pause();
      }
    });
    notifyListeners();
  }

  void play() {
    player.play();
    notifyListeners();
  }

  void pause() {
    player.pause();
    notifyListeners();
  }

  Future<Color> getImagePalette() async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
            NetworkImage(_currentPlaying!.coverImage));
    return paletteGenerator.dominantColor!.color;
  }
}
