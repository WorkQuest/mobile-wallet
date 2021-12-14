import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/constants.dart';

class GradientIcon extends StatelessWidget {
  final Widget icon;
  final double size;

  const GradientIcon({
    Key? key,
    required this.icon,
    required this.size,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: icon,
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return const LinearGradient(
          colors: <Color>[
            AppColor.enabledButton,
            Color(0xFF00AA5B),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(rect);
      },
    );
  }
}
