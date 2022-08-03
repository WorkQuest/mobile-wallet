import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workquest_wallet_app/utils/bottom_sheet.dart';
import 'package:workquest_wallet_app/widgets/dismiss_keyboard.dart';
import 'package:workquest_wallet_app/widgets/gradient_icon.dart';

import '../constants.dart';

class SwitchNetworkWidget<T> extends StatefulWidget {
  final T value;
  final List<T> items;
  final dynamic Function(dynamic value) onChanged;
  final Color colorText;
  final bool haveIcon;

  const SwitchNetworkWidget({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.items,
    this.colorText = Colors.white,
    this.haveIcon = false,
  }) : super(key: key);

  @override
  _SwitchNetworkWidgetState<T> createState() => _SwitchNetworkWidgetState<T>();
}

class _SwitchNetworkWidgetState<T> extends State<SwitchNetworkWidget> {
  @override
  Widget build(BuildContext context) {
    final _isWorkNet = _getTitleItem(widget.value.toString()) == 'WORKNET';

    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: ColoredBox(
        color: const Color(0xffF7F8FA),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _showDialog,
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 9.5, horizontal: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.haveIcon)
                    if (_isWorkNet)
                      GradientIcon(
                        icon: SvgPicture.asset(
                          _getPathIcons(_getTitleItem(widget.value.toString())),
                          width: 24,
                          height: 24,
                        ),
                        size: 24,
                      )
                    else
                      SvgPicture.asset(
                        _getPathIcons(_getTitleItem(widget.value.toString())),
                        width: 24,
                        height: 24,
                      ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    _getTitleItem(widget.value.toString()),
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.colorText,
                    ),
                  ),
                  const SizedBox(
                    width: 17,
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: widget.colorText,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showDialog() {
    BottomSheetUtils.showDefaultBottomSheet(
      context,
      height: 275,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color(0xffE9EDF2),
            ),
          ),
          const SizedBox(
            height: 21,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Choose network',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(
            height: 16.5,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: DismissKeyboard(
                child: Column(
                  children: [
                    for (int i = 0; i < widget.items.length; i++)
                      if (widget.value is Network)
                        _ItemEnvironmentWidget(
                          isEnabled: widget.value == widget.items[i],
                          onPressed: () {
                            widget.onChanged(widget.items[i]);
                            Navigator.pop(context);
                          },
                          title: _getName(
                              _getTitleItem(widget.items[i].toString())),
                        )
                      else
                        _ItemNetworkWidget(
                          isEnabled: widget.value == widget.items[i],
                          onPressed: () {
                            widget.onChanged(widget.items[i]);
                            Navigator.pop(context);
                          },
                          title: _getName(
                              _getTitleItem(widget.items[i].toString())),
                          pathIcon: widget.haveIcon
                              ? _getPathIcons(
                                  _getTitleItem(widget.items[i].toString()))
                              : null,
                          haveGradient:
                              _getTitleItem(widget.items[i].toString()) ==
                                  'WORKNET',
                        )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String _getPathIcons(String value) {
    if (value == 'WORKNET') {
      return 'assets/svg/wq_logo.svg';
    } else if (value == 'ETH') {
      return 'assets/svg/eth_logo.svg';
    } else if (value == 'BSC') {
      return 'assets/svg/bsc_logo.svg';
    } else {
      return 'assets/svg/polygon_logo.svg';
    }
  }

  String _getTitleItem(String value) {
    final _result = value.split('.').last;
    return '${_result.substring(0, 1).toUpperCase()}${_result.substring(1)}';
  }

  String _getName(String value) {
    if (value == 'WORKNET') {
      return 'WORKNET';
    } else if (value == 'ETH') {
      return 'Ethereum';
    } else if (value == 'BSC') {
      return 'Binance Smart Chain';
    } else if (value == 'POLYGON') {
      return 'Polygon';
    } else {
      return value;
    }
  }
}

class _ItemEnvironmentWidget extends StatelessWidget {
  final bool isEnabled;
  final String title;
  final Function() onPressed;

  const _ItemEnvironmentWidget({
    Key? key,
    required this.isEnabled,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: CupertinoButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 46,
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.check,
                  color: isEnabled ? Colors.black : Colors.transparent,
                  size: 25),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemNetworkWidget extends StatelessWidget {
  final bool isEnabled;
  final String? pathIcon;
  final String title;
  final Function() onPressed;
  final bool haveGradient;

  const _ItemNetworkWidget({
    Key? key,
    required this.isEnabled,
    required this.pathIcon,
    required this.title,
    required this.onPressed,
    this.haveGradient = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 5),
            if (pathIcon != null)
              if (haveGradient)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: GradientIcon(
                    icon: SvgPicture.asset(pathIcon!, width: 24, height: 24),
                    size: 35,
                  ),
                )
              else
                SvgPicture.asset(pathIcon!, width: 24, height: 24),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            if (isEnabled)
              const Icon(
                Icons.check,
                color: AppColor.enabledButton,
              ),
            const SizedBox(
              width: 4.0,
            )
          ],
        ),
      ),
    );
  }
}
