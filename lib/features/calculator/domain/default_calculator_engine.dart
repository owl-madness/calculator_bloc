import 'package:calculator_bloc/features/calculator/domain/calculator_engine.dart';

class DefaultCalculatorEngine implements CalculatorEngine {
  @override
  double? calculate(double first, double second, String operator) {
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
