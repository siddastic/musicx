import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/constants/color.dart';
import 'package:music_player/firebase_options.dart';
import 'package:music_player/providers/current_music_provider.dart';
import 'package:music_player/providers/favourite_provider.dart';
import 'package:music_player/providers/search_provider.dart';
import 'package:music_player/providers/user_profile_provider.dart';
import 'package:music_player/screens/auth/auth.dart';
import 'package:music_player/screens/tabs/subscreens/music_player.dart';
import 'package:music_player/screens/tabs/tabs.dart';
import 'package:music_player/screens/splash.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xff1e201e),
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentMusicProvider()),
        ChangeNotifierProvider(create: (_) => FavouriteProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musicx',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark()
            .textTheme
            .apply(fontFamily: GoogleFonts.jost().fontFamily),
        colorScheme: const ColorScheme.dark(
          primary: ConstantColors.primaryColor,
        ),
        scaffoldBackgroundColor: ConstantColors.scaffoldBackground,
      ),
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        AuthScreen.routeName: (context) => const AuthScreen(),
        TabScreen.routeName: (context) => const TabScreen(),
        MusicPlayerScreen.routeName: (context) => const MusicPlayerScreen(),
      },
    );
  }
}
