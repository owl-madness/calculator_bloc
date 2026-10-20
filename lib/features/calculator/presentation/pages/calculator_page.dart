import 'package:calculator_bloc/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:calculator_bloc/features/calculator/presentation/bloc/calculator_event.dart';
import 'package:calculator_bloc/features/calculator/presentation/bloc/calculator_state.dart';
import 'package:calculator_bloc/features/calculator/presentation/widgets/calculator_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              BlocBuilder<CalculatorBloc, CalculatorState>(
                builder: (context, state) {
                  final expression = state.previousValue != null &&
                          state.operator != null
                      ? '${_formatNumber(state.previousValue!)} ${_displayOperator(state.operator!)}'
                      : '';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        expression,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.currentValue,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    ...[
                      'C',
                      '⌫',
                      '÷',
                      '×',
                      '7',
                      '8',
                      '9',
                      '−',
                      '4',
                      '5',
                      '6',
                      '+',
                      '1',
                      '2',
                      '3',
                      '=',
                      '0',
                      '.'
                    ].map(
                      (label) => CalculatorButton(
                        label: label,
                        onPressed: () => _onButtonPressed(context, label),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onButtonPressed(BuildContext context, String label) {
    final bloc = context.read<CalculatorBloc>();

    if (RegExp(r'^\d$').hasMatch(label)) {
      bloc.add(DigitPressed(label));
      return;
    }

    switch (label) {
      case '.':
        bloc.add(const DecimalPressed());
      case '+':
        bloc.add(const OperatorPressed('+'));
      case '−':
        bloc.add(const OperatorPressed('-'));
      case '×':
        bloc.add(const OperatorPressed('*'));
      case '÷':
        bloc.add(const OperatorPressed('/'));
      case '=':
        bloc.add(const EqualsPressed());
      case 'C':
        bloc.add(const ClearPressed());
      case '⌫':
        bloc.add(const BackspacePressed());
    }
  }

  String _displayOperator(String operator) {
    switch (operator) {
      case '*':
        return '×';
      case '/':
        return '÷';
      case '-':
        return '−';
      default:
        return operator;
    }
  }

  String _formatNumber(double value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
  }
}
