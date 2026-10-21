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
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    void onPressed(String label) => _onButtonPressed(context, label);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: isLandscape
              ? const EdgeInsets.all(12)
              : const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: isLandscape
              ? Row(
                  children: [
                    Expanded(flex: 4, child: _Display()),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 5,
                      child: _Keypad(
                        rows: _rows,
                        onPressed: onPressed,
                        fillHeight: true,
                        spacing: 8,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Expanded(child: _Display()),
                    const SizedBox(height: 16),
                    _Keypad(rows: _rows, onPressed: onPressed),
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
  const _Keypad({
    required this.rows,
    required this.onPressed,
    this.fillHeight = false,
    this.spacing = 12,
  });

  final List<List<String>> rows;
  final ValueChanged<String> onPressed;

  /// When true, key height is derived from the available height
  /// (landscape) instead of the aspect ratio (portrait).
  final bool fillHeight;
  final double spacing;

  static const _columns = 4;
  static const _aspectRatio = 1.15;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth =
            (constraints.maxWidth - spacing * (_columns - 1)) / _columns;

        final cellHeight = fillHeight && constraints.hasBoundedHeight
            ? (constraints.maxHeight - spacing * (rows.length - 1)) /
                rows.length
            : cellWidth / _aspectRatio;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) SizedBox(height: spacing),
              SizedBox(
                height: cellHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var j = 0; j < rows[i].length; j++) ...[
                      if (j > 0) SizedBox(width: spacing),
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

  // '0' spans 3 columns, including the gaps between them.
  double _widthFor(String label, double cellWidth) {
    final span = label == '0' ? 3 : 1;
    return cellWidth * span + spacing * (span - 1);
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
