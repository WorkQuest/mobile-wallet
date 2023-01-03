import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/ui/withdraw_page/states_bank_page/withdraw_add_bank_card.dart';
import 'package:workquest_wallet_app/ui/withdraw_page/states_bank_page/withdraw_choose_bank_card.dart';

class WithdrawBankCard extends StatefulWidget {
  const WithdrawBankCard({Key? key}) : super(key: key);

  @override
  _WithdrawBankCardState createState() => _WithdrawBankCardState();
}

class _WithdrawBankCardState extends State<WithdrawBankCard>
    with TickerProviderStateMixin {
  bool _addingBankCard = true;

  void onTabChooseBank() {
    setState(() {
      _addingBankCard = !_addingBankCard;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 500),
      firstChild: WithdrawChooseBankCard(
        onTab: () {
          setState(() {
            _addingBankCard = !_addingBankCard;
          });
        },
      ),
      secondChild: const WithdrawAddBankCard(),
      crossFadeState: _addingBankCard
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );
  }
}
