import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:music_player/widgets/space.dart';

class Input extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String label;
  final String? hint;
  final String? prefixIcon;
  final String? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final Color? textColor;
  final bool readOnly;
  final void Function(String)? onChanged;
  const Input({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.autofillHints,
    this.textColor = Colors.white,
    this.readOnly = false,
    this.onChanged,
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  bool isFocused = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              widget.label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          AnimatedContainer(
            duration: 150.ms,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: isFocused
                    ? Theme.of(context).colorScheme.primary
                    : const Color(0xff242424),
              ),
              boxShadow: [
                if (isFocused)
                  const BoxShadow(
                    color: Color(0x3F9BB068),
                    blurRadius: 0,
                    offset: Offset(0, 0),
                    spreadRadius: 4,
                  ),
              ],
            ),
            child: Focus(
              onFocusChange: (value) => setState(() => isFocused = value),
              child: TextFormField(
                controller: widget.controller,
                validator: widget.validator,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                autofillHints: widget.autofillHints,
                readOnly: widget.readOnly,
                onChanged: widget.onChanged,
                style: TextStyle(
                  color: widget.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(16),
                  hintText: widget.hint,
                  hintStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  fillColor: const Color(0xff242424),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Space.h(14),
                            Image.asset(
                              widget.prefixIcon!,
                              width: 24,
                              height: 24,
                            ),
                          ],
                        )
                      : null,
                  suffixIcon: widget.suffixIcon != null
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Space.h(14),
                            Image.asset(
                              widget.suffixIcon!,
                              width: 24,
                              height: 24,
                              color: isFocused ? Colors.white : null,
                            ),
                          ],
                        )
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
