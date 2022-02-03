import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/default_textfield.dart';
import 'package:workquest_wallet_app/widgets/dismiss_keyboard.dart';

class DepositAddBankCard extends StatefulWidget {
  final Function()? onTab;

  const DepositAddBankCard({
    Key? key,
    required this.onTab,
  }) : super(key: key);

  @override
  _DepositAddBankCardState createState() => _DepositAddBankCardState();
}

class _DepositAddBankCardState extends State<DepositAddBankCard> {
  final TextEditingController _numberCardController = TextEditingController();
  final TextEditingController _nameCardHolderController =
      TextEditingController();
  final TextEditingController _dateCardController = TextEditingController();
  final TextEditingController _cvvCardController = TextEditingController();

  final _formNumberCardKey = GlobalKey<FormState>();
  final _formNameCardHolderKey = GlobalKey<FormState>();
  final _formDateCardKey = GlobalKey<FormState>();
  final _formCvvCardKey = GlobalKey<FormState>();

  bool get _statusButton =>
      _numberCardController.text.isNotEmpty &&
      _nameCardHolderController.text.isNotEmpty &&
      _dateCardController.text.isNotEmpty &&
      _cvvCardController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _numberCardController.addListener(() {
      _formNumberCardKey.currentState!.validate();
    });
    _nameCardHolderController.addListener(() {
      _formNameCardHolderKey.currentState!.validate();
    });
    _dateCardController.addListener(() {
      _formDateCardKey.currentState!.validate();
    });
    _cvvCardController.addListener(() {
      _formCvvCardKey.currentState!.validate();
    });
  }

  @override
  void dispose() {
    _numberCardController.dispose();
    _nameCardHolderController.dispose();
    _dateCardController.dispose();
    _cvvCardController.dispose();
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
              MediaQuery.of(context).padding.bottom,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Number of card',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 5,
              ),
              Form(
                key: _formNumberCardKey,
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
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 5,
              ),
              Form(
                key: _formNameCardHolderKey,
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
                          key: _formDateCardKey,
                          child: DefaultTextField(
                            controller: _dateCardController,
                            hint: '02/24',
                            suffixIcon: null,
                            inputFormatters: [
                              MaskTextInputFormatter(
                                mask: '##/##',
                                initialText: _dateCardController.text,
                              ),
                            ],
                            validator: (value) {
                              if (_dateCardController.text.length < 5) {
                                return "Incomplete date format";
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
                          key: _formCvvCardKey,
                          child: DefaultTextField(
                            controller: _cvvCardController,
                            hint: '242',
                            suffixIcon: null,
                            inputFormatters: [
                              MaskTextInputFormatter(
                                mask: '###',
                                initialText: _cvvCardController.text,
                              ),
                            ],
                            validator: (value) {
                              if (_cvvCardController.text.length < 3) {
                                return 'errors.incorrectFormat'.tr();
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
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.2,
              // ),
              const SizedBox(
                height: 20,
              ),
              Expanded(child: Container()),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: DefaultButton(
                    title: 'Add card',
                    onPressed: _statusButton
                        ? () {
                            if (_formNumberCardKey.currentState!.validate() &&
                                _formNameCardHolderKey.currentState!
                                    .validate() &&
                                _formDateCardKey.currentState!.validate() &&
                                _formCvvCardKey.currentState!.validate()) {
                              widget.onTab!.call();
                            }
                          }
                        : null,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
