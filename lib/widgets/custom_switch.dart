import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/constants.dart';

const backgroundDisabledColor = Color(0xffE9EDF2);
const disabledColor = Color(0xffAAB0B9);


class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  bool get isEnabled =>  _animationController!.value > 0.5;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 240,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Container(
            alignment: Alignment.centerLeft,
            width: 44.0,
            height: 26.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              color: isEnabled
                  ? AppColor.enabledButton
                  : backgroundDisabledColor,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  top: 4.0,
                  bottom: 4.0,
                  right: 4.0,
                  left: 4 + 18.0 * _animationController!.value),
              child: Container(
                width: 18.0,
                height: 18.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isEnabled ? Colors.white : AppColor.unselectedBottomIcon,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
