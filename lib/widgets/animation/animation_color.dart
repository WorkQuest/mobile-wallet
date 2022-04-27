import 'package:flutter/material.dart';

class AnimationColor extends StatefulWidget {
  final double width;
  final double height;
  final Color startColor;
  final Color endColor;
  final Duration duration;
  final bool enabled;

  const AnimationColor({
    Key? key,
    required this.width,
    required this.height,
    required this.startColor,
    required this.endColor,
    required this.duration,
    this.enabled = false,
  }) : super(key: key);

  @override
  _AnimationColorState createState() => _AnimationColorState();
}

class _AnimationColorState extends State<AnimationColor> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _colorTween;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: widget.duration);
    _colorTween = ColorTween(begin: widget.startColor, end: widget.endColor)
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enabled) {
      _animationController.forward().then((value) {
        _animationController.reverse();
      });
    }
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return child!;
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _colorTween.value,
        ),
      ),
    );
  }
}
