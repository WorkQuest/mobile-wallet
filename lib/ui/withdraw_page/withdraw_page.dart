import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/ui/withdraw_page/withdraw_bank_card.dart';
import 'package:workquest_wallet_app/widgets/custom_tab_bar.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/default_textfield.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({Key? key}) : super(key: key);

  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> with SingleTickerProviderStateMixin {
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
        title: 'Withdrawal',
      ),
      body: ColoredBox(
        color: Colors.white,
        child: Column(
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
                children: const [_WithdrawWalletAddress(), WithdrawBankCard()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WithdrawWalletAddress extends StatefulWidget {
  const _WithdrawWalletAddress({Key? key}) : super(key: key);

  @override
  _WithdrawWalletAddressState createState() => _WithdrawWalletAddressState();
}

class _WithdrawWalletAddressState extends State<_WithdrawWalletAddress> {
  late TextEditingController _addressController;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    // _addressController.dispose();
    // _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Scaffold(
        body: LayoutWithScroll(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'wallet.cryptoWallet'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              DefaultTextField(
                controller: _addressController,
                hint: 'wallet.enterAddress'.tr(),
                suffixIcon: null,
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: '0x########################################',
                    filter: {"#": RegExp(r'[0-9a-fA-F]')},
                    initialText: _addressController.text,
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'wallet.amount'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              DefaultTextField(
                controller: _amountController,
                hint: 'wallet.enterAmount'.tr(),
                suffixIcon: CupertinoButton(
                  padding: const EdgeInsets.only(right: 12.5),
                  child: Text(
                    'wallet.max'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColor.enabledButton,
                    ),
                  ),
                  onPressed: () {
                    _amountController.text = '9999';
                  },
                ),
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: '########',
                    initialText: _amountController.text,
                  ),
                ],
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        bottomNavigationBar: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
                right: 4.0,
                left: 4.0,
                bottom: MediaQuery.of(context).padding.bottom + 10.0),
            child: DefaultButton(
              title: 'wallet.withdraw'.tr(),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}
