import 'package:flutter/material.dart';

/// Thin wrapper over the themed [ElevatedButton] with a built-in loading
/// spinner state, so screens don't each re-implement the same pattern.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.minimumSize,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Size? minimumSize;

  @override
  Widget build(BuildContext context) {
    final style = minimumSize != null
        ? ElevatedButton.styleFrom(minimumSize: minimumSize)
        : null;
    if (isLoading) {
      return ElevatedButton(
        onPressed: null,
        style: style,
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      );
    }
    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon),
        label: Text(label),
      );
    }
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: Text(label),
    );
  }
}

/// Thin wrapper over the themed [OutlinedButton], mirroring [PrimaryButton]
/// for secondary / low-emphasis actions.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.minimumSize,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Size? minimumSize;

  @override
  Widget build(BuildContext context) {
    final style = minimumSize != null
        ? OutlinedButton.styleFrom(minimumSize: minimumSize)
        : null;
    if (icon != null) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon),
        label: Text(label),
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: style,
      child: Text(label),
    );
  }
}
