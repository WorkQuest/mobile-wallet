import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';

import '../../constants.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0);
const _cardNumber = '1234 1234 1234 9574';

class WithdrawInfoPage extends StatefulWidget {
  WithdrawInfoPage({Key? key}) : super(key: key);

  @override
  State<WithdrawInfoPage> createState() => _WithdrawInfoPageState();
}

class _WithdrawInfoPageState extends State<WithdrawInfoPage> {
  bool _hideNumber = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(
        title: 'wallet.withdraw'.tr(),
      ),
      body: Padding(
        padding: _padding,
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: AppColor.disabledButton,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: double.infinity,
                  ),
                  const Text(
                    'Wallet address',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _hideNumber = !_hideNumber;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          _hideNumber
                              ? textHideNumber(_cardNumber)
                              : _cardNumber,
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppColor.subtitleText,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          width: 6.5,
                        ),
                        SvgPicture.asset(Images.hideNumberCardIcon)
                      ],
                    ),
                  ),
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
                  const Text(
                    '15 WUSD',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.subtitleText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Total fee',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    '\$ 0,15',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.subtitleText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              child: SizedBox(
                width: double.infinity,
                child: DefaultButton(
                  title: 'Confirm',
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String textHideNumber(String number) {
    String line = '**** **** **** ****';
    line = line.substring(0, line.length - 4);
    line += number.substring(number.length - 4);
    return line;
  }
}
