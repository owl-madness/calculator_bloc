import 'package:equatable/equatable.dart';

class CalculatorState extends Equatable {
  final String currentValue;
  final double? previousValue;
  final String? operator;
  final bool justCalculated;
  final bool waitingForOperand;

  const CalculatorState({
    this.currentValue = '0',
    this.previousValue,
    this.operator,
    this.justCalculated = false,
    this.waitingForOperand = false,
  });

  CalculatorState copyWith({
    String? currentValue,
    double? previousValue,
    String? operator,
    bool clearPreviousValue = false,
    bool clearOperator = false,
    bool? justCalculated,
    bool? waitingForOperand,
  }) {
    return CalculatorState(
      currentValue: currentValue ?? this.currentValue,
      previousValue:
          clearPreviousValue ? null : previousValue ?? this.previousValue,
      operator: clearOperator ? null : operator ?? this.operator,
      justCalculated: justCalculated ?? this.justCalculated,
      waitingForOperand: waitingForOperand ?? this.waitingForOperand,
    );
  }

  @override
  List<Object?> get props => [
        currentValue,
        previousValue,
        operator,
        justCalculated,
        waitingForOperand,
      ];
}
