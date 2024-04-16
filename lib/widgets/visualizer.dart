import 'package:flutter/material.dart';
import 'package:siri_wave/siri_wave.dart';

class Visualizer extends StatelessWidget {
  final Color? primaryColor;
  final double? amplitude;
  const Visualizer({
    super.key,
    this.amplitude,
    required this.primaryColor,
  });
  @override
  Widget build(BuildContext context) {
    final controller = IOS7SiriWaveformController(
      amplitude: amplitude ?? 0.0,
      color: primaryColor ?? const Color(0xffA34B4B),
      frequency: 4,
      speed: 0.1,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 3),
      child: SiriWaveform.ios7(
        controller: controller,
        options: const IOS7SiriWaveformOptions(
          height: 40,
          width: 360,
        ),
      ),
    );
  }
}
