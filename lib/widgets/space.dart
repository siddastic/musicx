import 'package:flutter/material.dart';

class Space extends StatelessWidget {
  final double value;
  final bool isHorizontal;
  const Space({super.key, this.value = 16, this.isHorizontal = false});

  @override
  Widget build(BuildContext context) {
    return isHorizontal ? SizedBox(width: value) : SizedBox(height: value);
  }

  static Widget h(double value) => Space(value: value, isHorizontal: true);

  static Widget v(double value) => Space(value: value, isHorizontal: false);

  static const Widget v10 = Space(value: 10, isHorizontal: false);

  static const Widget v20 = Space(value: 20, isHorizontal: false);

  static const Widget h10 = Space(value: 10, isHorizontal: true);
}
