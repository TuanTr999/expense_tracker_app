import 'package:flutter/material.dart';

class AppCircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final double size;
  final Color color;
  final EdgeInsets? padding;

  const AppCircleButton({
    super.key,
    required this.onTap,
    required this.child,
    this.size = 50,
    this.color = Colors.white,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}