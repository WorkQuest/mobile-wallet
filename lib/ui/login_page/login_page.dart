import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/page_router.dart';
import 'package:workquest_wallet_app/ui/login_page/mobx/login_store.dart';
import 'package:workquest_wallet_app/ui/main_page/main_page.dart';
import 'package:workquest_wallet_app/ui/sign_up_page/sign_up_profile/sign_up_create_profile.dart';
import 'package:workquest_wallet_app/utils/alert_dialog.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/default_textfield.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';
import 'package:workquest_wallet_app/widgets/observer_consumer.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutWithScroll(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _HeaderScreen(),
              Padding(
                padding: _padding,
                child: _ContentScreen(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentScreen extends StatefulWidget {
  const _ContentScreen({Key? key}) : super(key: key);

  @override
  State<_ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<_ContentScreen> {
  final _formKey = GlobalKey<FormState>();
  final mnemonicController = TextEditingController();

  LoginStore store = LoginStore();

  @override
  void initState() {
    super.initState();
    mnemonicController.addListener(() {
      store.setMnemonic(mnemonicController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 50,
        ),
        const Text(
          'Mnemonic phrase',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Form(
          key: _formKey,
          child: DefaultTextField(
            controller: mnemonicController,
            hint: 'Enter mnemonic phrase',
            suffixIcon: null,
            inputFormatters: null,
            validator: (value) {
              if (mnemonicController.text.length <= 24) {
                return "A small number of words";
              }
              if (mnemonicController.text.split(' ').toList().length < 12) {
                return "Incorrect mnemonic format";
              }
              return null;
            },
            prefitIcon: null,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ObserverListener(
              store: store,
              onFailure: () {
                Navigator.of(context, rootNavigator: true).pop();
                return false;
              },
              onSuccess: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await AlertDialogUtils.showSuccessDialog(context);
                PageRouter.pushNewReplacementRoute(context, const MainPage());
              },
              child: SizedBox(
                width: double.infinity,
                child: Observer(
                  builder: (_) {
                    return DefaultButton(
                      onPressed: store.statusButton
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                AlertDialogUtils.showLoadingDialog(context);
                                store.login(mnemonicController.text);
                              }
                            }
                          : null,
                      title: 'Login',
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Or',
              style: TextStyle(
                fontSize: 16,
                color: AppColor.disabledText,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: DefaultButton(
                onPressed: () {
                  PageRouter.pushNewRoute(context, const SignUpCreateProfile());
                },
                title: 'Create profile',
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _HeaderScreen extends StatelessWidget {
  const _HeaderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      padding: _padding,
      decoration: BoxDecoration(
        color: AppColor.blue,
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(4.0),
          bottomLeft: Radius.circular(4.0),
        ),
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.66), BlendMode.dstOut),
          image: const AssetImage(Images.loginImage),
          fit: BoxFit.fill,
        ),
      ),
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Welcome to\nWorkQuest Wallet',
            style: TextStyle(
              fontSize: 34,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Please sign in',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontStyle: FontStyle.normal,
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
