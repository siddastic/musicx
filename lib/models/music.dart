class Music {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String coverImage;
  final String coverGif;
  final String path;
  final bool explicit;

  const Music({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.coverImage,
    required this.path,
    required this.coverGif,
    this.explicit = false,
  });

  // operator == will be used to compare two objects of Music
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Music && other.id == id;
  }

  // hashCode property will be used to generate a hash code for the object
  @override
  int get hashCode => id.hashCode;
}
