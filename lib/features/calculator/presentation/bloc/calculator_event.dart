sealed class CalculatorEvent {
  const CalculatorEvent();
}

final class DigitPressed extends CalculatorEvent {
  final String digit;

  const DigitPressed(this.digit);
}

final class OperatorPressed extends CalculatorEvent {
  final String operator;

  const OperatorPressed(this.operator);
}

final class DecimalPressed extends CalculatorEvent {
  const DecimalPressed();
}

final class EqualsPressed extends CalculatorEvent {
  const EqualsPressed();
}

final class BackspacePressed extends CalculatorEvent {
  const BackspacePressed();
}

final class ClearPressed extends CalculatorEvent {
  const ClearPressed();
}
