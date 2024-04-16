import 'package:flutter/material.dart';

class BackgroundGradient extends StatelessWidget {
  final Widget child;
  final double layerOpacity;
  final Color? primaryColor;
  const BackgroundGradient({
    super.key,
    required this.child,
    this.layerOpacity = .5,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.1, 0.7],
          colors: [
            (primaryColor ?? const Color(0xff45171F)).withOpacity(layerOpacity),
            const Color(0xff0E0E0E).withOpacity(layerOpacity),
          ],
        ),
      ),
      child: child,
    );
  }
}
