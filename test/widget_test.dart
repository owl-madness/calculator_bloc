import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculator_bloc/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:calculator_bloc/features/calculator/presentation/pages/calculator_page.dart';
import 'package:calculator_bloc/features/calculator/presentation/widgets/calculator_button.dart';

void main() {
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => CalculatorBloc(),
        child: const CalculatorPage(),
      ),
    );
  }

  testWidgets('Calculator page renders in landscape (default test viewport)',
      (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CalculatorPage), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
    expect(find.text('='), findsOneWidget);

    // '0' appears twice: once in the display, once on the keypad button
    expect(find.text('0'), findsNWidgets(2));

    // Alternatively, verify the specific '0' button:
    expect(
      find.descendant(
        of: find.byType(CalculatorButton),
        matching: find.text('0'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Calculator page renders in portrait without layout overflow',
      (tester) async {
    tester.view.physicalSize = const Size(400, 850);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CalculatorPage), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
    expect(find.text('='), findsOneWidget);
    expect(find.text('0'), findsNWidgets(2));
  });
}
