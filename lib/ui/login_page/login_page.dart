import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/page_router.dart';
import 'package:workquest_wallet_app/ui/login_page/mobx/login_store.dart';
import 'package:workquest_wallet_app/ui/pin_code_page/pin_code_page.dart';
import 'package:workquest_wallet_app/ui/sign_up_page/sign_up/sign_up_page.dart';
import 'package:workquest_wallet_app/utils/alert_dialog.dart';
import 'package:workquest_wallet_app/utils/validators.dart';
import 'package:workquest_wallet_app/widgets/animation/login_button.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/default_textfield.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';
import 'package:workquest_wallet_app/widgets/observer_consumer.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
        // bottomNavigationBar: Padding(
        //     padding: EdgeInsets.only(
        //       left: 16.0,
        //       bottom: MediaQuery.of(context).padding.bottom + 10,
        //     ),
        //     child: const Text('Version 2.0.0')),
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
          height: 16,
        ),
        const Text(
          'wallet',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ).tr(gender: 'mnemonic_phrase'),
        const SizedBox(
          height: 5,
        ),
        Form(
          key: _formKey,
          child: DefaultTextField(
            controller: mnemonicController,
            hint: 'wallet.enterMnemonicPhrase'.tr(),
            isPassword: true,
            suffixIcon: null,
            inputFormatters: null,
            validator: (value) =>
                Validators.loginMnemonic(mnemonicController.text),
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
                return false;
              },
              onSuccess: () async {
                await AlertDialogUtils.showSuccessDialog(context);
                PageRouter.pushNewReplacementRoute(
                    context, const PinCodePage());
              },
              child: Observer(
                builder: (_) {
                  final function = store.statusButton
                      ? !store.isLoading
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                store.login(mnemonicController.text);
                              }
                            }
                          : () {}
                      : null;
                  return LoginButton(
                    enabled: store.isLoading,
                    onTap: function,
                    title: 'signIn'.tr(gender: 'login'),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'signIn'.tr(gender: 'or'),
              style: const TextStyle(
                fontSize: 16,
                color: AppColor.disabledText,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: Observer(
                builder: (_) => DefaultButton(
                  onPressed: store.isLoading
                      ? null
                      : () {
                          PageRouter.pushNewRoute(context, const SignUpPage());
                        },
                  title: 'wallet.createWallet'.tr(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
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
        children: [
          Expanded(child: Container()),
          Text(
            '${'startPage.welcome'.tr()} WorkQuest Wallet',
            style: const TextStyle(
              fontSize: 34,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'signIn.pleaseSignIn'.tr(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontStyle: FontStyle.normal,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
