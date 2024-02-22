import 'package:flutter/material.dart';

class AnimatedText extends StatefulWidget {
  final Widget text;
  final int duration;
  const AnimatedText({
    super.key,
    required this.text,
    required this.duration,
  });

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1),
      curve: Curves.easeIn,
      duration: Duration(milliseconds: widget.duration),
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: widget.text);
      },
    );
  }
}
