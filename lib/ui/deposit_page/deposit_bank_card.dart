import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/ui/deposit_page/states_bank_page/deposit_add_bank_card.dart';
import 'package:workquest_wallet_app/ui/deposit_page/states_bank_page/deposit_choose_bank_card.dart';
import 'package:workquest_wallet_app/utils/alert_dialog.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';

class DepositBankCard extends StatefulWidget {
  const DepositBankCard({Key? key}) : super(key: key);

  @override
  State<DepositBankCard> createState() => _DepositBankCardState();
}

class _DepositBankCardState extends State<DepositBankCard>
    with TickerProviderStateMixin {
  bool _addingBankCard = true;
  bool _firstShow = true;

  void onTabNotBankCards() {
    setState(() {
      _addingBankCard = !_addingBankCard;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _NotBankCards(
      onTab: () {
        AlertDialogUtils.showInfoAlertDialog(context,
            title: 'wallet.underConstruction'.tr(),
            content: 'meta.serviceUnavailable'.tr());
        setState(() {
          _addingBankCard = !_addingBankCard;
        });
      },
    );
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 500),
      firstChild: _firstShow
          ? _NotBankCards(
              onTab: () {
                setState(() {
                  _addingBankCard = !_addingBankCard;
                });
              },
            )
          : const DepositChooseBankCard(),
      secondChild: DepositAddBankCard(
        onTab: () {
          setState(() {
            _firstShow = !_firstShow;
            _addingBankCard = !_addingBankCard;
          });
        },
      ),
      crossFadeState: _addingBankCard
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );
  }
}

class _NotBankCards extends StatelessWidget {
  final Function()? onTab;

  const _NotBankCards({
    Key? key,
    required this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: Container()),
            SizedBox(
              width: 125,
              height: 100,
              child: SvgPicture.asset(
                Images.notCardsIcon,
                color: AppColor.disabledButton,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'wallet.addCartToContinue'.tr(),
              style: const TextStyle(
                fontSize: 16,
                color: AppColor.disabledText,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(child: Container())
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            right: 16.0,
            left: 16.0,
            bottom: MediaQuery.of(context).padding.bottom + 10),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: DefaultButton(
              onPressed: onTab,
              title: 'wallet.addCard'.tr(),
            ),
          ),
        ),
      ),
    );
  }
}
