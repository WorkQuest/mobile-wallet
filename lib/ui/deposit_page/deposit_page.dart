import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/ui/deposit_page/deposit_bank_card.dart';
import 'package:workquest_wallet_app/utils/snack_bar.dart';
import 'package:workquest_wallet_app/widgets/custom_tab_bar.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';

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
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 20.0,
          bottom: 10.0 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          children: [
            CustomTabBar(
              tabController: _tabController,
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
      ),
    );
  }
}

class _WalletAddress extends StatelessWidget {
  const _WalletAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 25,
        ),
        Container(
          height: 206,
          width: 206,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColor.disabledButton,
            ),
            borderRadius: BorderRadius.circular(6.0),
            image: const DecorationImage(
              image: AssetImage(
                Images.scanQRExample,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Scan QR code or copy address to receive payment',
          style: TextStyle(
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
          child: const Text(
            '0xf376g...G7f3g8b',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        Expanded(child: Container()),
        Row(
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
                  child: const Text(
                    'Share',
                    style: TextStyle(
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
                title: 'Copy',
                onPressed: () => _copyPressed(context),
              ),
            )
          ],
        ),
      ],
    );
  }

  void _sharePressed() {
    //TODO Make a copy of the address
    Share.share('test');
  }

  void _copyPressed(BuildContext context) {
    //TODO Make a copy of the address
    SnackBarUtils.success(context,
        title: 'Copied!', duration: const Duration(milliseconds: 500));
  }
}
