import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/default_textfield.dart';
import 'package:workquest_wallet_app/widgets/dismiss_keyboard.dart';
import 'package:workquest_wallet_app/widgets/info_element.dart';

import '../../../constants.dart';
import '../../../utils/alert_dialog.dart';

final List<_CardBank> _cardsBanks = [
  _CardBank('Visa', '*0000'),
  _CardBank('MasterCard', '*1234'),
  _CardBank('Tinkoff', '*1111'),
  _CardBank('Visa', '*0000'),
];

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

class _CardBank {
  String nameBank;
  String numberCard;

  _CardBank(
    this.nameBank,
    this.numberCard,
  );
}

class WithdrawChooseBankCard extends StatefulWidget {
  final Function()? onTab;

  const WithdrawChooseBankCard({
    Key? key,
    required this.onTab,
  }) : super(key: key);

  @override
  _WithdrawChooseBankCardState createState() => _WithdrawChooseBankCardState();
}

class _WithdrawChooseBankCardState extends State<WithdrawChooseBankCard> {
  final _amountController = TextEditingController();
  final _formAmount = GlobalKey<FormState>();

  _CardBank _currentCard = _cardsBanks[0];

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      _formAmount.currentState!.validate();
    });
  }

  @override
  void dispose() {
    // _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Scaffold(
        body: DismissKeyboard(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Form(
                        key: _formAmount,
                        child: DefaultTextField(
                          hint: '0 WUSD',
                          suffixIcon: null,
                          controller: _amountController,
                          inputFormatters: [
                            MaskTextInputFormatter(
                              mask: '#######',
                              initialText: _amountController.text,
                            ),
                          ],
                          validator: (value) {
                            if (_amountController.text.isEmpty) {
                              return "errors.fieldEmpty".tr();
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 31,
                      height: 45,
                      child: Center(
                        child: Text(
                          '=',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: InfoElement(
                        line: '\$ 0',
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'wallet.table.trxFee'.tr(),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  width: double.infinity,
                  child: InfoElement(line: '\$ 0,15'),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'wallet.chooseCard'.tr(),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () => _chooseCard(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 17.0, vertical: 15),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColor.disabledButton,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: 16,
                          width: 20,
                          child: SvgPicture.asset(
                            Images.notCardsIcon,
                            color: AppColor.enabledButton,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          '${_currentCard.nameBank} ${_currentCard.numberCard}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        // Expanded(
                        //   child: Container(),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 3.5,
                          ),
                          child: SvgPicture.asset(
                            Images.chooseCoinIcon,
                            color: AppColor.enabledButton,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.18,
                // ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
              bottom: 10 + MediaQuery.of(context).padding.bottom),
          child: SizedBox(
            width: double.infinity,
            child: DefaultButton(
              title: 'wallet.withdraw'.tr(),
              onPressed: () {
                if (_formAmount.currentState!.validate()) {
                  AlertDialogUtils.showInfoAlertDialog(context,
                      title: 'meta.warning'.tr(),
                      content: 'meta.serviceUnavailable'.tr());
                  widget.onTab!.call();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void _selectCard(_CardBank card) {
    setState(() {
      _currentCard = card;
    });
  }

  void _chooseCard() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 350,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'wallet.chooseCard'.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 16.5,
                    ),
                    ..._cardsBanks
                        .map(
                          (card) => Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _selectCard(card);
                                  Navigator.pop(context);
                                },
                                child: ListTile(
                                  title: Text(
                                    '${card.nameBank} ${card.numberCard}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 1,
                                color: AppColor.disabledButton,
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
