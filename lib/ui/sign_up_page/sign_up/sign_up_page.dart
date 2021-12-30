import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/ui/sign_up_page/sign_up/mobx/sign_up_store.dart';
import 'package:workquest_wallet_app/ui/sign_up_page/sign_up/sign_up_choose_page.dart';
import 'package:workquest_wallet_app/utils/alert_dialog.dart';
import 'package:workquest_wallet_app/utils/snack_bar.dart';
import 'package:workquest_wallet_app/widgets/custom_switch.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  SignUpStore store = SignUpStore();

  @override
  void initState() {
    super.initState();
    store.generateMnemonic();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        backgroundColor: Colors.white,
        appBar: DefaultAppBar(
          onPressed: () {
            AlertDialogUtils.showAlertDialog(
              context,
              title: const Text('Warning!'),
              content: const Text(
                  'If you leave the page, you will not link the wallet to your profile.\nAre you sure?'),
              needCancel: true,
              titleCancel: "Cancel",
              titleOk: "Return",
              onTabCancel: null,
              onTabOk: () => Navigator.pop(context),
              colorCancel: AppColor.enabledButton,
              colorOk: Colors.red,
            );
          },
        ),
        body: LayoutWithScroll(
          child: Padding(
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
                _YourPhrase(phrase: store.mnemonic),
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
                      value: store.isSaved,
                      onChanged: (value) => store.setIsSaved(value),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: DefaultButton(
                      title: 'Next',
                      onPressed: store.isSaved ? _pushSignUpChoosePage : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pushSignUpChoosePage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Provider(
          create: (_) => store,
          child: const SignUpChoosePage(),
        ),
      ),
    );
  }
}

class _YourPhrase extends StatelessWidget {
  final String? phrase;

  const _YourPhrase({
    required this.phrase,
    Key? key,
  }) : super(key: key);

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
          child: Text(
            phrase ?? "",
            style: const TextStyle(
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
              Clipboard.setData(ClipboardData(text: phrase));
              SnackBarUtils.success(
                context,
                title: 'Copied!',
                duration: const Duration(milliseconds: 250),
              );
            },
            title: 'Copy phrase',
          ),
        ),
      ],
    );
  }
}
