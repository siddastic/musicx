import 'package:flutter/material.dart';

class SheetOption {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SheetOption({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
