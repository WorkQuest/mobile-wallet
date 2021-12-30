import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';

const _padding = EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0);

class DepositInfoPage extends StatelessWidget {
  const DepositInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const DefaultAppBar(
        title: 'Deposit info',
      ),
      body: Padding(
        padding: _padding,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: AppColor.disabledButton,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Wallet address',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '83479B2E7809F7D7C0A9184EEDA74CCF122ABF3147CB4572BDEBD252F8E352A8',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.subtitleText,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Amount',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '15 WUSD',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.subtitleText,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Total fee',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '\$ 0,15',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.subtitleText,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom),
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
}
