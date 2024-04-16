# Musicx

Better music player

<!-- demo apk link -->
[Download APK](https://github.com/siddastic/musicx/releases/tag/v2)

## Features

- Sync favourite songs across devices (Email based authentication)
- Background Miniclip for every song
- Search for songs (by name, artist, album)

### Preview

<!-- Preview video -->
<video src = "https://github.com/siddastic/musicx/assets/47083394/b995a2e0-7497-4be4-b056-a2f5e41291da" width = "150"> </video>


## Testing

Tests are stored in the `test` directory. To run the tests, use the following command:

```bash
flutter test test/{file_name}.dart
```

currently two tests are written for both type of tests i.e. unit and widget test. The tests are stored in the following files :
unit test in file `library_test.dart` and widget test in file `input_widget_test.dart`

Note :

It uses firebase for authentication and firestore for storing user data, once authenticated user can add songs to their favourite list and can access them from any device.
(Offline persistence is implemented for adding/removing songs to/from favourite list)
