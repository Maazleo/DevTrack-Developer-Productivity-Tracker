// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:devtrack_developer_productivity_tracker/main.dart';

void main() {
  testWidgets('App loads and shows home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that appbar title appears
    expect(find.text('Dashboard'), findsOneWidget);
    
    // Verify that greeting appears
    expect(find.text('Hello, Maaz 👋'), findsOneWidget);
    
    // The test will pass if the basic UI renders without errors
  });
}
