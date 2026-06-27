import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:bipstock/main.dart';

void main() {
  testWidgets('renders cadastro page', (tester) async {
    await tester.pumpWidget(const AplicativoBipstock());

    expect(find.text('Cadastro'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(5));
    expect(find.text('Continuar'), findsOneWidget);
    expect(find.text('Ja tenho cadastro'), findsOneWidget);
  });
}

