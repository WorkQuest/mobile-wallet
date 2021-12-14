import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

class ConfirmTransferPage extends StatefulWidget {
  const ConfirmTransferPage({Key? key}) : super(key: key);

  @override
  _ConfirmTransferPageState createState() => _ConfirmTransferPageState();
}

class _ConfirmTransferPageState extends State<ConfirmTransferPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const DefaultAppBar(
        title: 'Transfer',
      ),
      body: Padding(
        padding: _padding,
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            const _InformationWidget(),
            Expanded(child: Container()),
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 10.0),
              child: SizedBox(
                width: double.infinity,
                child: DefaultButton(
                  onPressed: () {},
                  title: 'Confirm',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _InformationWidget extends StatelessWidget {
  const _InformationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0), color: AppColor.disabledButton),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Recipient address',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
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
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
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
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
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
    );
  }
}
