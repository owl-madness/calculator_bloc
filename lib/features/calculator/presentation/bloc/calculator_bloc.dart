import 'dart:async';

import 'package:calculator_bloc/features/calculator/presentation/bloc/calculator_event.dart';
import 'package:calculator_bloc/features/calculator/presentation/bloc/calculator_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc() : super(const CalculatorState()) {
    on<DigitPressed>(_onDigitPressed);
    on<DecimalPressed>(_onDecimalPressed);
    on<OperatorPressed>(_onOperatorPressed);
    on<EqualsPressed>(_onEqualsPressed);
    on<ClearPressed>(_onClearPressed);
    on<BackspacePressed>(_onBackspacePressed);
  }

  FutureOr<void> _onDigitPressed(
      DigitPressed event, Emitter<CalculatorState> emit) {
    final currentValue = state.currentValue;

    final newValue = state.justCalculated || currentValue == '0'
        ? event.digit
        : currentValue + event.digit;

    emit(
      state.copyWith(
        currentValue: newValue,
        justCalculated: false,
      ),
    );
  }

  void _onDecimalPressed(
    DecimalPressed event,
    Emitter<CalculatorState> emit,
  ) {
    if (state.justCalculated) {
      emit(
        state.copyWith(
          currentValue: '0.',
          clearPreviousValue: true,
          clearOperator: true,
          justCalculated: false,
        ),
      );
      return;
    }

    final currentValue = state.currentValue;

    if (currentValue.contains('.')) {
      return;
    }

    emit(
      state.copyWith(
        currentValue: '$currentValue.',
      ),
    );
  }

  void _onOperatorPressed(
    OperatorPressed event,
    Emitter<CalculatorState> emit,
  ) {
    final currentNumber = double.tryParse(state.currentValue);

    if (currentNumber == null) return;

    final previousValue = state.previousValue;
    final currentOperator = state.operator;

    // Calculate the pending operation first.
    if (previousValue != null && currentOperator != null) {
      final result = _calculate(
        previousValue,
        currentNumber,
        currentOperator,
      );

      if (result == null) {
        emit(
          state.copyWith(
            currentValue: 'Error',
            clearPreviousValue: true,
            clearOperator: true,
            justCalculated: true,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          previousValue: result,
          operator: event.operator,
          currentValue: '0',
          justCalculated: false,
        ),
      );
      return;
    }

    // No pending operation: store the current number.
    emit(
      state.copyWith(
        previousValue: currentNumber,
        operator: event.operator,
        currentValue: '0',
        justCalculated: false,
      ),
    );
  }

  void _onEqualsPressed(
    EqualsPressed event,
    Emitter<CalculatorState> emit,
  ) {
    final first = state.previousValue;
    final second = double.tryParse(state.currentValue);
    final operator = state.operator;

    if (first == null || second == null || operator == null) {
      return;
    }

    final result = _calculate(first, second, operator);

    if (result == null) {
      emit(
        state.copyWith(
          currentValue: 'Error',
          clearOperator: true,
          clearPreviousValue: true,
          justCalculated: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        currentValue: result.toString(),
        clearOperator: true,
        clearPreviousValue: true,
        justCalculated: true,
      ),
    );
  }

  void _onClearPressed(ClearPressed event, Emitter<CalculatorState> emit) {
    emit(const CalculatorState());
  }

  void _onBackspacePressed(
    BackspacePressed event,
    Emitter<CalculatorState> emit,
  ) {
    final currentValue = state.currentValue;

    if (currentValue.isEmpty || currentValue == 'Error') {
      return;
    }

    final newValue = currentValue.length > 1
        ? currentValue.substring(0, currentValue.length - 1)
        : '0';

    emit(
      state.copyWith(
        currentValue: newValue == '-' ? '0' : newValue,
        justCalculated: false,
      ),
    );
  }

  double? _calculate(double first, double second, String operator) {
    switch (operator) {
      case '+':
        return first + second;
      case '-':
        return first - second;
      case '*':
        return first * second;
      case '/':
        if (second == 0) return null;
        return first / second;
      default:
        return null;
    }
  }
}
