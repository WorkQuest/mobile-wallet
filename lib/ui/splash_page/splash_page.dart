import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/page_router.dart';
import 'package:workquest_wallet_app/ui/login_page/login_page.dart';
import 'package:workquest_wallet_app/ui/pin_code_page/pin_code_page.dart';
import 'package:workquest_wallet_app/ui/splash_page/mobx/splash_store.dart';
import 'package:workquest_wallet_app/utils/alert_dialog.dart';
import 'package:workquest_wallet_app/widgets/gradient_icon.dart';
import 'package:workquest_wallet_app/widgets/observer_consumer.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  SplashStore store = SplashStore();

  @override
  void initState() {
    super.initState();
    store.sign();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ObserverListener(
        store: store,
        onSuccess: () {
          if (store.isLoginPage!) {
            PageRouter.pushNewReplacementRoute(context, const LoginPage());
          } else {
            PageRouter.pushNewReplacementRoute(context, const PinCodePage());
          }
        },
        onFailure: () {
          AlertDialogUtils.showAlertDialog(
            context,
            title: const Text("Warning"),
            content: Text(store.errorMessage!),
            needCancel: true,
            titleCancel: "Login Page",
            titleOk: "Retry",
            onTabCancel: () {
              PageRouter.pushNewReplacementRoute(context, const LoginPage());
            },
            onTabOk: () => store.sign(),
            colorCancel: AppColor.enabledButton,
            colorOk: AppColor.enabledButton,
          );
          return true;
        },
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Row(
                  children: [
                    const Spacer(),
                    const SizedBox(
                      width: 37,
                    ),
                    GradientIcon(
                      icon: SvgPicture.asset(Images.wqLogo),
                      size: MediaQuery.of(context).size.width * 0.32,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
