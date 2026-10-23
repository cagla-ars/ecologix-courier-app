import 'dart:math';
import 'package:flutter/material.dart';

class MobileContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const MobileContainer({
    super.key,
    required this.child,
    this.maxWidth = 430,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = min(constraints.maxWidth, maxWidth);

        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: width,
            child: child,
          ),
        );
      },
    );
  }
}