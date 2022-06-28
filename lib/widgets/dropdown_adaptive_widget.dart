import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/constants.dart';

const _styleTextItem = TextStyle(color: Colors.black);

class DropDownAdaptiveWidget extends StatefulWidget {
  final ConfigNameNetwork value;
  final Function(ConfigNameNetwork? network)? onChanged;

  const DropDownAdaptiveWidget({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _DropDownAdaptiveWidgetState createState() => _DropDownAdaptiveWidgetState();
}

class _DropDownAdaptiveWidgetState extends State<DropDownAdaptiveWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              Text(
                _getTitleItem(widget.value.name),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
            ],
          ),
          if (Platform.isAndroid)
            Positioned.fill(
              child: Opacity(
                opacity: 0.0,
                child: DropdownCard(
                  child: DropdownButton<ConfigNameNetwork>(
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    iconEnabledColor: Colors.white,
                    value: widget.value,
                    isDense: true,
                    items: [
                      DropdownMenuItem<ConfigNameNetwork>(
                        value: ConfigNameNetwork.mainnet,
                        onTap: () {},
                        child: Text(
                          _getTitleItem(ConfigNameNetwork.mainnet.name),
                          style: _styleTextItem,
                        ),
                      ),
                      DropdownMenuItem<ConfigNameNetwork>(
                        value: ConfigNameNetwork.testnet,
                        onTap: () {},
                        child: Text(
                          _getTitleItem(ConfigNameNetwork.testnet.name),
                          style: _styleTextItem,
                        ),
                      ),
                      DropdownMenuItem<ConfigNameNetwork>(
                        value: ConfigNameNetwork.devnet,
                        onTap: () {},
                        child: Text(
                          _getTitleItem(ConfigNameNetwork.devnet.name),
                          style: _styleTextItem,
                        ),
                      ),
                    ],
                    onChanged: widget.onChanged,
                  ),
                ),
              ),
            ),
          if (Platform.isIOS)
            Positioned.fill(
              child: InkWell(
                onTap: () {
                  final children = [
                    ConfigNameNetwork.mainnet,
                    ConfigNameNetwork.testnet,
                    ConfigNameNetwork.devnet,
                  ];
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    builder: (BuildContext context) {
                      var changedEmployment = widget.value;
                      return Container(
                        height: 150.0 + MediaQuery.of(context).padding.bottom,
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CupertinoPicker(
                                scrollController: FixedExtentScrollController(
                                  initialItem: children.indexOf(widget.value),
                                ),
                                itemExtent: 32.0,
                                onSelectedItemChanged: (int index) {
                                  changedEmployment = children[index];
                                },
                                children: children
                                    .map((e) => Center(child: Text(_getTitleItem(e.name))))
                                    .toList(),
                              ),
                            ),
                            CupertinoButton(
                              child: const Text("OK"),
                              onPressed: () {
                                widget.onChanged!.call(changedEmployment);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(),
              ),
            )
        ],
      ),
    );
  }

  String _getTitleItem(String value) {
    return '${value.substring(0, 1).toUpperCase()}${value.substring(1)}';
  }
}

class DropdownCard extends StatefulWidget {
  final DropdownButton child;

  const DropdownCard({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _DropdownCardState createState() => _DropdownCardState();
}

class _DropdownCardState extends State<DropdownCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButtonHideUnderline(
          child: widget.child,
        ),
      ),
    );
  }
}
