import 'package:calculator_bloc/features/calculator/domain/calculator_engine.dart';
import 'package:calculator_bloc/features/calculator/domain/default_calculator_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CalculatorEngine engine;

  setUp(() {
    engine = DefaultCalculatorEngine();
  });

  group('CalculatorEngine', () {
    test('adds two numbers', () {
      expect(engine.calculate(10, 5, '+'), 15);
    });

    test('subtracts two numbers', () {
      expect(engine.calculate(10, 5, '-'), 5);
    });

    test('multiplies two numbers', () {
      expect(engine.calculate(10, 5, '*'), 50);
    });

    test('divides two numbers', () {
      expect(engine.calculate(10, 5, '/'), 2);
    });

    test('returns null when dividing by zero', () {
      expect(engine.calculate(10, 0, '/'), isNull);
    });

    test('returns null for an unsupported operator', () {
      expect(engine.calculate(10, 5, '%'), isNull);
    });

    test('supports decimal calculations', () {
      expect(engine.calculate(2.5, 1.5, '+'), 4.0);
    });
  });
}
