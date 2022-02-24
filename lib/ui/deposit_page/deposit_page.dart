import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/ui/deposit_page/deposit_bank_card.dart';
import 'package:workquest_wallet_app/utils/snack_bar.dart';
import 'package:workquest_wallet_app/widgets/custom_tab_bar.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';

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
      appBar: const DefaultAppBar(
        title: 'Deposit',
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

class _WalletAddress extends StatelessWidget {
  const _WalletAddress({Key? key}) : super(key: key);

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
              data: AccountRepository().userAddress!,
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: AppColor.disabledButton,
                ),
              ),
              child: Text(
                // '0xf376g...G7f3g8b',
                '${AccountRepository().userAddress!.substring(0, 7)}...${AccountRepository()
                    .userAddress!.substring(AccountRepository().userAddress!.length - 7,
                    AccountRepository().userAddress!.length)}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(right: 16.0, left: 16.0, bottom: MediaQuery
            .of(context)
            .padding
            .bottom + 10,),
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
    Share.share('${AccountRepository().userAddress}',);
  }

  void _copyPressed(BuildContext context) {
    Clipboard.setData(ClipboardData(text: AccountRepository().userAddress));
    SnackBarUtils.success(
      context,
      title: 'wallet.copy'.tr(),
      duration: const Duration(milliseconds: 500),
    );
  }
}
