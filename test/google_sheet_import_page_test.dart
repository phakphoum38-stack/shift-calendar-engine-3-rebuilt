import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Google Sheet import page can host Material content', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('Google Sheets import'),
        ),
      ),
    );

    expect(find.text('Google Sheets import'), findsOneWidget);
  });
}
