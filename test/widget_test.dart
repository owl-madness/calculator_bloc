import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculator_bloc/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:calculator_bloc/features/calculator/presentation/pages/calculator_page.dart';

void main() {
  testWidgets('Calculator page renders', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => CalculatorBloc(),
          child: const CalculatorPage(),
        ),
      ),
    );

    expect(find.text('Calculator'), findsOneWidget);
  });
}
