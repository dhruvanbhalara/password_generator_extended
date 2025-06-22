// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:password_generator_extended_example/main.dart' show ExampleApp;

void main() {
  group('PasswordGeneratorApp', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    testWidgets('renders initial UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(const ExampleApp());
      await tester.pumpAndSettle(); // Wait for animations

      // Verify basic UI elements are present
      expect(find.text('Password Generator Example'), findsOneWidget);
      expect(find.text('Generated Password:'), findsOneWidget);
      expect(find.byType(SelectableText), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byIcon(Icons.copy), findsOneWidget);
      expect(find.text('Generate New Password'), findsOneWidget);
      expect(find.text('Copy Password'), findsOneWidget);
      expect(find.text('Password Options'), findsOneWidget);
    });

    testWidgets('generates new password on button press', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ExampleApp());
      await tester.pumpAndSettle();

      // Get initial password
      final initialPasswordWidget =
          find.byType(SelectableText).evaluate().first.widget as SelectableText;
      final initialPassword = initialPasswordWidget.data!;

      // Tap generate button and wait for animation
      await tester.tap(find.text('Generate New Password'));
      await tester.pump(); // Start animation
      await tester.pumpAndSettle(); // Wait for animation to complete

      // Get new password
      final newPasswordWidget =
          find.byType(SelectableText).evaluate().first.widget as SelectableText;
      final newPassword = newPasswordWidget.data!;

      // Verify password changed
      expect(initialPassword, isNot(equals(newPassword)));
    });

    testWidgets('copies password to clipboard', (WidgetTester tester) async {
      // Mock clipboard data
      final mockClipboard = <String, dynamic>{};
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall methodCall) async {
          if (methodCall.method == 'Clipboard.setData') {
            mockClipboard['text'] = methodCall.arguments['text'];
            return null;
          }
          if (methodCall.method == 'Clipboard.getData') {
            return mockClipboard;
          }
          return null;
        },
      );

      await tester.pumpWidget(const ExampleApp());
      await tester.pumpAndSettle();

      // Get the generated password
      final passwordWidget =
          find.byType(SelectableText).evaluate().first.widget as SelectableText;
      final password = passwordWidget.data!;

      // Test copy button
      await tester.tap(find.text('Copy Password'));
      await tester.pumpAndSettle();

      // Verify clipboard content using mock
      expect(mockClipboard['text'], equals(password));

      // Verify snackbar appears
      expect(find.text('Password copied to clipboard'), findsOneWidget);
    });

    testWidgets('updates password options', (WidgetTester tester) async {
      await tester.pumpWidget(const ExampleApp());
      await tester.pumpAndSettle();

      // Test length slider
      final Slider slider = tester.widget(find.byType(Slider));
      expect(slider.value, equals(12.0)); // Default length

      // Test character type checkboxes
      expect(
          tester
              .widget<CheckboxListTile>(
                find.widgetWithText(
                    CheckboxListTile, 'Uppercase Letters (A-Z)'),
              )
              .value,
          isTrue);
      expect(
          tester
              .widget<CheckboxListTile>(
                find.widgetWithText(
                    CheckboxListTile, 'Lowercase Letters (a-z)'),
              )
              .value,
          isTrue);
      expect(
          tester
              .widget<CheckboxListTile>(
                find.widgetWithText(CheckboxListTile, 'Numbers (0-9)'),
              )
              .value,
          isTrue);
      expect(
          tester
              .widget<CheckboxListTile>(
                find.widgetWithText(
                    CheckboxListTile, 'Special Characters (!@#\$...)'),
              )
              .value,
          isTrue);
    });
  });
}
