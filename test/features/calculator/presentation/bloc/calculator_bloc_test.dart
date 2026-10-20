import 'package:bloc_test/bloc_test.dart';
import 'package:calculator_bloc/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:calculator_bloc/features/calculator/presentation/bloc/calculator_event.dart';
import 'package:calculator_bloc/features/calculator/presentation/bloc/calculator_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalculatorBloc', () {
    blocTest<CalculatorBloc, CalculatorState>(
      'emits currentValue 7 when DigitPressed(7) is added',
      build: CalculatorBloc.new,
      act: (bloc) => bloc.add(const DigitPressed('7')),
      expect: () => [
        const CalculatorState(currentValue: '7'),
      ],
    );

    blocTest<CalculatorBloc, CalculatorState>(
      'calculates 12 + 5 = 17',
      build: CalculatorBloc.new,
      act: (bloc) {
        bloc
          ..add(const DigitPressed('1'))
          ..add(const DigitPressed('2'))
          ..add(const OperatorPressed('+'))
          ..add(const DigitPressed('5'))
          ..add(const EqualsPressed());
      },
      expect: () => [
        const CalculatorState(currentValue: '1'),
        const CalculatorState(currentValue: '12'),
        const CalculatorState(
          currentValue: '12',
          previousValue: 12,
          operator: '+',
          waitingForOperand: true,
        ),
        const CalculatorState(
          currentValue: '5',
          previousValue: 12,
          operator: '+',
        ),
        const CalculatorState(
          currentValue: '17',
          justCalculated: true,
        ),
      ],
    );

    blocTest<CalculatorBloc, CalculatorState>(
      'calculates sequential operations: 12 + 5 + 3 = 20',
      build: CalculatorBloc.new,
      act: (bloc) {
        bloc
          ..add(const DigitPressed('1'))
          ..add(const DigitPressed('2'))
          ..add(const OperatorPressed('+'))
          ..add(const DigitPressed('5'))
          ..add(const OperatorPressed('+'))
          ..add(const DigitPressed('3'))
          ..add(const EqualsPressed());
      },
      expect: () => [
        const CalculatorState(currentValue: '1'),
        const CalculatorState(currentValue: '12'),
        const CalculatorState(
          currentValue: '12',
          previousValue: 12,
          operator: '+',
          waitingForOperand: true,
        ),
        const CalculatorState(
          currentValue: '5',
          previousValue: 12,
          operator: '+',
        ),
        const CalculatorState(
          currentValue: '5',
          previousValue: 17,
          operator: '+',
          waitingForOperand: true,
        ),
        const CalculatorState(
          currentValue: '3',
          previousValue: 17,
          operator: '+',
        ),
        const CalculatorState(
          currentValue: '20',
          justCalculated: true,
        ),
      ],
    );

    blocTest<CalculatorBloc, CalculatorState>(
      'emits Error when dividing by zero',
      build: CalculatorBloc.new,
      act: (bloc) {
        bloc
          ..add(const DigitPressed('1'))
          ..add(const OperatorPressed('/'))
          ..add(const DigitPressed('0'))
          ..add(const EqualsPressed());
      },
      expect: () => [
        const CalculatorState(currentValue: '1'),
        const CalculatorState(
          currentValue: '1',
          previousValue: 1,
          operator: '/',
          waitingForOperand: true,
        ),
        const CalculatorState(
          currentValue: '0',
          previousValue: 1,
          operator: '/',
        ),
        const CalculatorState(
          currentValue: 'Error',
          justCalculated: true,
        ),
      ],
    );
    blocTest<CalculatorBloc, CalculatorState>(
      'removes the last digit when BackspacePressed is added',
      build: CalculatorBloc.new,
      act: (bloc) {
        bloc
          ..add(const DigitPressed('1'))
          ..add(const DigitPressed('2'))
          ..add(const BackspacePressed());
      },
      expect: () => [
        const CalculatorState(currentValue: '1'),
        const CalculatorState(currentValue: '12'),
        const CalculatorState(currentValue: '1'),
      ],
    );

    blocTest<CalculatorBloc, CalculatorState>(
      'resets display to 0 when backspace removes the only digit',
      build: CalculatorBloc.new,
      act: (bloc) {
        bloc
          ..add(const DigitPressed('7'))
          ..add(const BackspacePressed());
      },
      expect: () => [
        const CalculatorState(currentValue: '7'),
        const CalculatorState(currentValue: '0'),
      ],
    );

    blocTest<CalculatorBloc, CalculatorState>(
      'allows only one decimal point in a number',
      build: CalculatorBloc.new,
      act: (bloc) {
        bloc
          ..add(const DigitPressed('1'))
          ..add(const DecimalPressed())
          ..add(const DigitPressed('5'))
          ..add(const DecimalPressed());
      },
      expect: () => [
        const CalculatorState(currentValue: '1'),
        const CalculatorState(currentValue: '1.'),
        const CalculatorState(currentValue: '1.5'),
      ],
    );
  });
}
