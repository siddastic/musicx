class MusicxUser {
  final String username;
  final String email;

  MusicxUser({required this.username, required this.email});

  factory MusicxUser.fromJson(Map<String, dynamic> json) {
    return MusicxUser(
      username: json['username'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
    };
  }
}
