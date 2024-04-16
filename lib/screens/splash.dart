import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:music_player/screens/auth/auth.dart';
import 'package:music_player/screens/tabs/tabs.dart';
import 'package:music_player/widgets/space.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double scale = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          scale = 1;
        });
      });
      transitionToNextScreen();
    });
  }

  void transitionToNextScreen() async {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.of(context).pushReplacementNamed(TabScreen.routeName);
        } else {
          Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: scale,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: SizedBox(
                height: 75,
                width: 75,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                  height: 50,
                  width: 50,
                ),
              ),
            ),
            Space.h10,
            Container(
              height: 35,
              width: 89,
              decoration: const BoxDecoration(),
              clipBehavior: Clip.antiAlias,
              child: Transform.translate(
                offset: const Offset(0, -1.5),
                child: TextLiquidFill(
                  boxWidth: 90.0,
                  boxHeight: 40.0,
                  loadDuration: const Duration(milliseconds: 1500),
                  waveDuration: const Duration(milliseconds: 1000),
                  text: 'Musicx',
                  waveColor: Theme.of(context).colorScheme.primary,
                  boxBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  textStyle: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ).animate().fadeIn(),
      ),
    );
  }
}
