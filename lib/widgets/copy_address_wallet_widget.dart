import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/session_repository.dart';
import 'package:workquest_wallet_app/service/address_service.dart';
import 'package:workquest_wallet_app/utils/snack_bar.dart';
import 'package:workquest_wallet_app/widgets/dropdown_card.dart';
import 'package:workquest_wallet_app/widgets/switch_format_address_widget.dart';

class CopyAddressWalletWidget extends StatefulWidget {
  final FormatAddress format;

  const CopyAddressWalletWidget({
    Key? key,
    required this.format,
  }) : super(key: key);

  @override
  State<CopyAddressWalletWidget> createState() =>
      _CopyAddressWalletWidgetState();
}

class _CopyAddressWalletWidgetState extends State<CopyAddressWalletWidget> {
  late FormatAddress _format;

  @override
  void initState() {
    _format = widget.format;
    super.initState();
  }

  String get address {
    if (GetIt.I.get<SessionRepository>().isOtherNetwork) {
      return GetIt.I.get<SessionRepository>().userWallet?.address ??
          '111111111111111111';
    }
    return _format == FormatAddress.BECH32
        ? AddressService.hexToBech32(
            GetIt.I.get<SessionRepository>().userWallet?.address ??
                '111111111111111111')
        : GetIt.I.get<SessionRepository>().userWallet?.address ??
            '111111111111111111';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<NetworkName?>(
      valueListenable: GetIt.I.get<SessionRepository>().networkName,
      builder: (_, value, child) {
        return SliverToBoxAdapter(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!GetIt.I.get<SessionRepository>().isOtherNetwork)
                  Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 150,
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Text(
                                  _format.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                SvgPicture.asset(Images.arrowDropDownIcon),
                              ],
                            ),
                            if (Platform.isAndroid)
                              Positioned.fill(
                                child: Opacity(
                                  opacity: 0.0,
                                  child: DropdownCard(
                                    child: DropdownButton<FormatAddress>(
                                      items: FormatAddress.values.map((format) {
                                        return DropdownMenuItem<FormatAddress>(
                                          value: format,
                                          child: Text(format.name),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _format = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            if (Platform.isIOS)
                              Positioned.fill(
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: _showCupertinoActionSheet,
                                  child: const SizedBox.shrink(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${address.substring(0, 9)}...${address.substring(address.length - 3, address.length)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColor.subtitleText,
                      ),
                    ),
                    const Spacer(),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      pressedOpacity: 0.2,
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: address));
                        SnackBarUtils.success(
                          context,
                          title: 'wallet.copy'.tr(),
                          duration: const Duration(milliseconds: 1000),
                        );
                      },
                      child: Container(
                        height: 34,
                        width: 34,
                        padding: const EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: AppColor.disabledButton),
                        child: SvgPicture.asset(
                          Images.walletCopyIcon,
                          color: AppColor.enabledButton,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCupertinoActionSheet() {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: FormatAddress.values
            .map((format) => CupertinoActionSheetAction(
                child: Text(format.name),
                onPressed: () async {
                  setState(() {
                    _format = format;
                  });
                  Navigator.pop(context);
                }))
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          child: Text('meta.cancel'.tr()),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
