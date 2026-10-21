import 'package:calculator_bloc/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:calculator_bloc/features/calculator/presentation/bloc/calculator_event.dart';
import 'package:calculator_bloc/features/calculator/presentation/bloc/calculator_state.dart';
import 'package:calculator_bloc/features/calculator/presentation/widgets/calculator_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  static const _rows = [
    ['C', '⌫', '÷', '×'],
    ['7', '8', '9', '−'],
    ['4', '5', '6', '+'],
    ['1', '2', '3', '='],
    ['0', '.'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            children: [
              Expanded(child: _Display()),
              const SizedBox(height: 16),
              _Keypad(
                rows: _rows,
                onPressed: (label) => _onButtonPressed(context, label),
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
}

class _Keypad extends StatelessWidget {
  const _Keypad({required this.rows, required this.onPressed});

  final List<List<String>> rows;
  final ValueChanged<String> onPressed;

  static const _columns = 4;
  static const _spacing = 12.0;
  static const _aspectRatio = 1.15;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth =
            (constraints.maxWidth - _spacing * (_columns - 1)) / _columns;
        final cellHeight = cellWidth / _aspectRatio;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) const SizedBox(height: _spacing),
              SizedBox(
                height: cellHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var j = 0; j < rows[i].length; j++) ...[
                      if (j > 0) const SizedBox(width: _spacing),
                      SizedBox(
                        width: _widthFor(rows[i][j], cellWidth),
                        child: CalculatorButton(
                          label: rows[i][j],
                          onPressed: () => onPressed(rows[i][j]),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  // '0' spans the 3 columns left over beside '.', including the gaps between them.
  double _widthFor(String label, double cellWidth) {
    final span = label == '0' ? 3 : 1;
    return cellWidth * span + _spacing * (span - 1);
  }
}

class _Display extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<CalculatorBloc, CalculatorState>(
      builder: (context, state) {
        final expression = state.previousValue != null && state.operator != null
            ? '${_formatNumber(state.previousValue!)} ${_displayOperator(state.operator!)}'
            : '';

        return Align(
          alignment: Alignment.bottomRight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                expression,
                style: TextStyle(
                  fontSize: 22,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    state.currentValue,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
    if (value.isFinite && value.abs() <= 9007199254740991) {
      return value % 1 == 0 ? value.toInt().toString() : value.toString();
    }
    return value.toString();
  }
}
