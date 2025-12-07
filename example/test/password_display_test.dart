import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator_extended/password_generator_extended.dart';
import 'package:password_generator_extended_example/widgets/password_display.dart';

void main() {
  group('PasswordDisplay', () {
    testWidgets('renders password and strength', (WidgetTester tester) async {
      final animationController = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(milliseconds: 100),
      );
      final animation =
          Tween<double>(begin: 0, end: 1).animate(animationController);
      animationController.forward();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordDisplay(
              password: 'test-password',
              strength: PasswordStrength.strong,
              fadeAnimation: animation,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Generated Password:'), findsOneWidget);
      expect(find.text('test-password'), findsOneWidget);
      expect(find.text('Strong'),
          findsOneWidget); // Assuming Strength indicator shows text
    });
  });
}
