import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  const CalculatorButton({
    super.key,
    this.onPressed,
    required this.label,
  });

  final VoidCallback? onPressed;
  final String label;

  static const _operators = {'÷', '×', '−', '+'};
  static const _actions = {'C', '⌫'};

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final Color background;
    final Color foreground;

    if (label == '=') {
      background = scheme.primary;
      foreground = scheme.onPrimary;
    } else if (_operators.contains(label)) {
      background = scheme.secondaryContainer;
      foreground = scheme.onSecondaryContainer;
    } else if (_actions.contains(label)) {
      background = scheme.tertiaryContainer;
      foreground = scheme.onTertiaryContainer;
    } else {
      background = scheme.surfaceContainerHigh;
      foreground = scheme.onSurface;
    }

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        padding: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        textStyle: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w400,
        ),
      ),
      child: Text(label),
    );
  }
}
