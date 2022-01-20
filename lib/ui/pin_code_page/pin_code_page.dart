import 'dart:math';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/ui/login_page/login_page.dart';
import 'package:workquest_wallet_app/ui/main_page/main_page.dart';
import 'package:workquest_wallet_app/ui/pin_code_page/mobx/pin_code_store.dart';
import 'package:workquest_wallet_app/utils/alert_dialog.dart';
import 'package:workquest_wallet_app/utils/storage.dart';
import 'package:workquest_wallet_app/widgets/observer_consumer.dart';

import '../../page_router.dart';

class PinCodePage extends StatefulWidget {
  const PinCodePage({Key? key}) : super(key: key);

  @override
  _PinCodePageState createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage>
    with SingleTickerProviderStateMixin {
  PinCodeStore store = PinCodeStore();
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    store.init();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 150,
      ),
    );
    animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController!.reverse();
      }
    });
  }

  String getTitle() {
    if (store.statePin == StatePinCode.check) {
      return 'pinCode'.tr(gender: 'writePinCode');
    } else if (store.statePin == StatePinCode.create) {
      return 'pinCode'.tr(gender: 'comeUp');
    } else {
      return 'pinCode'.tr(gender: 'repeat');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ObserverListener(
      onFailure: () {
        print('onFailure');
        Navigator.of(context, rootNavigator: true).pop();
        HapticFeedback.lightImpact();
        animationController!.forward();
        return true;
      },
      onSuccess: () async {
        Navigator.of(context, rootNavigator: true).pop();
        if (store.statePin == StatePinCode.toLogin) {
          await Storage.deleteAllFromSecureStorage();
          AccountRepository().clearData();
          PageRouter.pushNewRemoveRoute(context, const LoginPage());
        } else if (store.statePin == StatePinCode.success) {
          await AlertDialogUtils.showSuccessDialog(context);
          PageRouter.pushNewReplacementRoute(context, const MainPage());
        }
      },
      store: store,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Observer(
          builder: (_) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: 110,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    getTitle(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xff353C47),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                AnimatedBuilder(
                  animation: animationController!,
                  builder: (context, child) {
                    final sineValue =
                        sin(4 * 2 * pi * animationController!.value);
                    return Observer(
                      builder: (_) => Transform.translate(
                        offset: Offset(sineValue * 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 1; i < 5; i++)
                              Container(
                                height: 10,
                                width: 10,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 7.5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: store.pinCode.length >= i
                                      ? AppColor.enabledButton
                                      : const Color(0xffE9EDF2),
                                ),
                              )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                if (store.attempts != 0)
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      '${'pinCode'.tr(gender: 'attempts_left')}: ${3 - store.attempts}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  ),
                SizedBox(
                  height: store.attempts != 0 ? 15 : 20,
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    primary: false,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 30,
                    children: [
                      for (int i = 1; i < 10; i++)
                        KeyboardButton(
                          child: Text(
                            i.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          onTab: () async {
                            HapticFeedback.lightImpact();
                            await store.inputPin(i);
                            if (store.pinCode.length == 4) {
                              AlertDialogUtils.showLoadingDialog(context);
                              store.signIn();
                            }
                          },
                        ),
                      KeyboardButton(
                        child: SvgPicture.asset(
                          Images.biometricIcon,
                          color: store.canBiometrics
                              ? AppColor.enabledButton
                              : const Color(0xffF7F8FA),
                        ),
                        onTab: () async {
                          if (store.canBiometrics) {
                            HapticFeedback.lightImpact();
                            AlertDialogUtils.showLoadingDialog(context);
                            await store.biometricScan();
                          }
                        },
                      ),
                      KeyboardButton(
                        child: const Text(
                          '0',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        onTab: () async {
                          HapticFeedback.lightImpact();
                          await store.inputPin(0);
                          if (store.pinCode.length == 4) {
                            AlertDialogUtils.showLoadingDialog(context);
                            store.signIn();
                          }
                        },
                      ),
                      KeyboardButton(
                        child: SvgPicture.asset(Images.removePinIcon),
                        onTab: () {
                          HapticFeedback.lightImpact();
                          store.removePin();
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KeyboardButton extends StatelessWidget {
  final Widget child;
  final Function()? onTab;

  const KeyboardButton({
    Key? key,
    required this.child,
    required this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTab,
      child: Container(
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: const Color(0xffF7F8FA),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
