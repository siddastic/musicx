import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_player/widgets/input.dart';

void main() {
  testWidgets('Input widget has a label and hint', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Input(label: 'Title', hint: 'Enter title here'),
        ),
      ),
    );
    await tester.pump();

    // Verify that the label and hint are displayed.
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Enter title here'), findsOneWidget);
  });
}
