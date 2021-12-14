import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/ui/sign_up_page/sign_up_choose_page.dart';
import 'package:workquest_wallet_app/widgets/custom_switch.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';

import '../../page_router.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _savedPhrase = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const DefaultAppBar(),
      body: Padding(
        padding: _padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Save this phrase to be able to login in next time',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const _YourPhrase(),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                const Text(
                  'I’ve saved mnemonic phrase',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                CustomSwitch(
                  value: _savedPhrase,
                  onChanged: (value) {
                    setState(() {
                      _savedPhrase = value;
                    });
                  },
                )
              ],
            ),
            Expanded(child: Container()),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 10.0),
              child: SizedBox(
                width: double.infinity,
                child: DefaultButton(
                  title: 'Next',
                  onPressed: _savedPhrase ? _pushSignUpChoosePage : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pushSignUpChoosePage() {
    PageRouter.pushNewRoute(context, const SignUpChoosePage());
  }
}

class _YourPhrase extends StatelessWidget {
  const _YourPhrase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your phrase',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 11.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: AppColor.disabledButton,
            ),
          ),
          child: const Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xff1D2127),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 171,
          child: DefaultButton(
            onPressed: () {

            },
            title: 'Copy phrase',
          ),
        ),
      ],
    );
  }
}
