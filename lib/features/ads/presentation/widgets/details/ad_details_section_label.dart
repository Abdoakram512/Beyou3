import 'package:flutter/material.dart';

class AdDetailsSectionLabel extends StatelessWidget {
  final String label;

  const AdDetailsSectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.grey,
            letterSpacing: 1.1,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}
