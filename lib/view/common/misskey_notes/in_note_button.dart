import 'package:flutter/material.dart';
import 'package:miria/view/themes/app_theme.dart';

class InNoteButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;

  const InNoteButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppTheme.of(context).buttonBackground,
        foregroundColor: Theme.of(context).textTheme.bodyMedium?.color,
        padding: const EdgeInsets.all(5),
        textStyle: TextStyle(
            fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize),
        minimumSize: const Size(double.infinity, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: child,
    );
  }
}
