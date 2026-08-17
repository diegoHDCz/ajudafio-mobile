import 'package:ajudafio_mobile/core/utils/phone_input_formatter.dart';
import 'package:ajudafio_mobile/features/auth/presentation/pages/signup_page.dart';
import 'package:ajudafio_mobile/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Finder phoneField() => find.descendant(
    of: find.byWidgetPredicate(
      (widget) => widget is AuthField && widget.hintText == 'Phone',
    ),
    matching: find.byType(TextFormField),
  );

  testWidgets('formats digits as (XX) XXXXX-XXXX while typing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

    await tester.enterText(phoneField(), '45984090113');
    await tester.pump();

    final field = tester.widget<TextFormField>(phoneField());
    expect(field.controller!.text, '(45) 98409-0113');
  });

  testWidgets('ignores non-digit characters and caps at 11 digits', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

    await tester.enterText(phoneField(), '(45) 98409-0113999');
    await tester.pump();

    final field = tester.widget<TextFormField>(phoneField());
    expect(field.controller!.text, '(45) 98409-0113');
  });

  testWidgets('validator rejects incomplete phone and accepts complete one', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

    expect(phoneValidator('(45) 98409-011'), isNotNull);
    expect(phoneValidator(''), isNotNull);
    expect(phoneValidator(null), isNotNull);
    expect(phoneValidator('(45) 98409-0113'), isNull);
  });

  test('sanitizePhone strips formatting down to digits', () {
    expect(sanitizePhone('(45) 98409-0113'), '45984090113');
  });
}
