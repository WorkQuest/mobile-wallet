import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/session_repository.dart';
import 'package:workquest_wallet_app/service/address_service.dart';
import 'package:workquest_wallet_app/ui/deposit_page/deposit_bank_card.dart';
import 'package:workquest_wallet_app/utils/snack_bar.dart';
import 'package:workquest_wallet_app/widgets/custom_tab_bar.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/switch_format_address_widget.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

class DepositPage extends StatefulWidget {
  const DepositPage({Key? key}) : super(key: key);

  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'wallet.deposit'.tr(),
      ),
      body: Column(
        children: [
          Padding(
            padding: _padding,
            child: CustomTabBar(
              tabController: _tabController,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _WalletAddress(),
                DepositBankCard(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _WalletAddress extends StatefulWidget {
  const _WalletAddress({Key? key}) : super(key: key);

  @override
  State<_WalletAddress> createState() => _WalletAddressState();
}

class _WalletAddressState extends State<_WalletAddress> {
  late FormatAddress _format;

  @override
  void initState() {
    _format = GetIt.I.get<SessionRepository>().isOtherNetwork
        ? FormatAddress.HEX
        : FormatAddress.BECH32;
    super.initState();
  }

  String get address {
    return _format == FormatAddress.BECH32
        ? AddressService.hexToBech32(
            GetIt.I.get<SessionRepository>().userWallet!.address!)
        : GetIt.I.get<SessionRepository>().userWallet!.address!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: _padding,
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            QrImage(
              data: address,
              version: QrVersions.auto,
              size: 206,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'wallet.scanQr'.tr(),
              style: const TextStyle(
                fontSize: 16,
                color: AppColor.subtitleText,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (!GetIt.I.get<SessionRepository>().isOtherNetwork)
              SwitchFormatAddressWidget(
                format: _format,
                onChanged: (FormatAddress value) {
                  setState(() {
                    _format = value;
                  });
                },
              ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 12.5, horizontal: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: AppColor.disabledButton,
                ),
              ),
              child: Text(
                '${address.substring(0, 7)}...${address.substring(address.length - 7, address.length)}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          right: 16.0,
          left: 16.0,
          bottom: MediaQuery.of(context).padding.bottom + 10,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                pressedOpacity: 0.2,
                onPressed: _sharePressed,
                child: Container(
                  height: 43,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    'meta.share'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColor.enabledButton,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: DefaultButton(
                title: 'meta.copy'.tr(),
                onPressed: () => _copyPressed(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _sharePressed() {
    Share.share(address);
  }

  void _copyPressed(BuildContext context) {
    Clipboard.setData(ClipboardData(text: address));
    SnackBarUtils.success(
      context,
      title: 'wallet.copy'.tr(),
      duration: const Duration(milliseconds: 500),
    );
  }
}
