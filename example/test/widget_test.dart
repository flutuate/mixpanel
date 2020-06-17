// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutuate_mixpanel_example/main.dart';

void main() {
  testWidgets('Verify widget has three button or message about missing token',
      (WidgetTester tester) async {

    // Add your Mixpanel token here.
    final String mixpanelToken = null;

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(mixpanelToken));

    // Verify that platform version is retrieved.
    expect(
      find.byWidgetPredicate((Widget widget) {
        if (widget is Text) {
          return widget.data.startsWith('Press me to track') ||
              widget.data == 'Your Mixpanel Token was not informed';
        }
        return false;
      }),
      findsOneWidget,
    );
  });
}
