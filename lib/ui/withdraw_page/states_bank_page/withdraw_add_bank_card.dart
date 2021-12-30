import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:workquest_wallet_app/widgets/custom_checkbox.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/default_textfield.dart';
import 'package:workquest_wallet_app/widgets/dismiss_keyboard.dart';
import 'package:workquest_wallet_app/widgets/info_element.dart';

import '../../../page_router.dart';
import '../withdraw_info_page.dart';

class WithdrawAddBankCard extends StatefulWidget {
  const WithdrawAddBankCard({Key? key}) : super(key: key);

  @override
  _WithdrawAddBankCardState createState() => _WithdrawAddBankCardState();
}

final _formsKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
];

class _WithdrawAddBankCardState extends State<WithdrawAddBankCard> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _numberCardController = TextEditingController();
  final TextEditingController _nameCardHolderController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  bool _saveCard = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      _formsKeys[0].currentState!.validate();
    });
    _numberCardController.addListener(() {
      _formsKeys[1].currentState!.validate();
    });
    _nameCardHolderController.addListener(() {
      _formsKeys[2].currentState!.validate();
    });
    _dateController.addListener(() {
      _formsKeys[3].currentState!.validate();
    });
    _cvvController.addListener(() {
      _formsKeys[4].currentState!.validate();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _numberCardController.dispose();
    _nameCardHolderController.dispose();
    _dateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height -
              50.0 -
              20.0 -
              50.0 -
              50.0 -
              10.0 -
              5.0 -
              MediaQuery.of(context).padding.bottom,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Amount',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Form(
                      key: _formsKeys[0],
                      child: DefaultTextField(
                        hint: '0 WUSD',
                        suffixIcon: null,
                        controller: _amountController,
                        inputFormatters: [
                          MaskTextInputFormatter(
                            mask: '#########',
                            initialText: _amountController.text,
                          ),
                        ],
                        validator: (value) {
                          if (_amountController.text.isEmpty) {
                            return 'Field is empty';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 31,
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
              const Text(
                'Number of card',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Form(
                key: _formsKeys[1],
                child: DefaultTextField(
                  controller: _numberCardController,
                  hint: '1234 1234 1234 1234',
                  suffixIcon: null,
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '#### #### #### ####',
                      initialText: _numberCardController.text,
                    ),
                  ],
                  validator: (value) {
                    if (_numberCardController.text.length < 19) {
                      return "Incomplete card number";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Cardholder name',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Form(
                key: _formsKeys[2],
                child: DefaultTextField(
                  controller: _nameCardHolderController,
                  hint: '1234 1234 1234 1234',
                  suffixIcon: null,
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '#### #### #### ####',
                      initialText: _nameCardHolderController.text,
                    ),
                  ],
                  validator: (value) {
                    if (_nameCardHolderController.text.length < 19) {
                      return "Incomplete card number";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Date',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Form(
                          key: _formsKeys[3],
                          child: DefaultTextField(
                            controller: _dateController,
                            hint: '02/24',
                            suffixIcon: null,
                            inputFormatters: [
                              MaskTextInputFormatter(
                                mask: '##/##',
                                initialText: _dateController.text,
                              ),
                            ],
                            validator: (value) {
                              if (_dateController.text.length < 5){
                                return "Incorrect format";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CVV',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Form(
                          key: _formsKeys[4],
                          child: DefaultTextField(
                            controller: _cvvController,
                            hint: '242',
                            suffixIcon: null,
                            inputFormatters: [
                              MaskTextInputFormatter(
                                mask: '###',
                                initialText: _cvvController.text,
                              ),
                            ],
                            validator: (value) {
                              if (_cvvController.text.length < 3) {
                                return "Incorrect format";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _saveCard = !_saveCard;
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomCheckBox(
                      value: _saveCard,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Text(
                      'Save card for next payment',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: DefaultButton(
                  title: 'Withdraw',
                  onPressed: () async {
                    final result = await PageRouter.pushNewRoute(context, WithdrawInfoPage());
                    if (result != null && result) {
                      Navigator.pop(context);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
