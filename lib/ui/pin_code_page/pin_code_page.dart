import 'dart:math';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/http/web_socket.dart';
import 'package:workquest_wallet_app/page_router.dart';
import 'package:workquest_wallet_app/repository/session_repository.dart';
import 'package:workquest_wallet_app/ui/login_page/login_page.dart';
import 'package:workquest_wallet_app/ui/main_page/main_page.dart';
import 'package:workquest_wallet_app/ui/main_page/notify/notify_page.dart';
import 'package:workquest_wallet_app/ui/pin_code_page/mobx/pin_code_store.dart';
import 'package:workquest_wallet_app/utils/alert_dialog.dart';
import 'package:workquest_wallet_app/widgets/animation/animation_color.dart';
import 'package:workquest_wallet_app/widgets/animation/animation_compression.dart';
import 'package:workquest_wallet_app/widgets/animation/animation_switch.dart';
import 'package:workquest_wallet_app/widgets/observer_consumer.dart';

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
      return 'pinCode.writePinCode'.tr();
    } else if (store.statePin == StatePinCode.create) {
      return 'pinCode.comeUp'.tr();
    } else {
      return 'pinCode.repeat'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ObserverListener(
      onFailure: () {
        HapticFeedback.lightImpact();
        animationController!.forward();
        return true;
      },
      onSuccess: () async {
        if (store.statePin == StatePinCode.toLogin) {
          /// Failed
          GetIt.I.get<SessionRepository>().clearData();
          PageRouter.pushNewRemoveRoute(context, const LoginPage());
        } else if (store.successData == StatePinCode.success) {
          /// Success
          GetIt.I.get<SessionRepository>().connectClient();
          WebSocket().init();
          await AlertDialogUtils.showSuccessDialog(context);
          PageRouter.pushNewRemoveRoute(
            context,
            ChangeNotifierProvider(
              create: (context) => NotifyPage(),
              child: const MainPage(),
            ),
          );
        }
      },
      store: store,
      child: WillPopScope(
        onWillPop: () async => false,
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
                  if (store.statePin == StatePinCode.check)
                    _elementField(
                      title: 'pinCode.writePinCode'.tr(),
                      pinCode: store.pinCode,
                      isLoading: store.startAnimation,
                      activateAnimation: true,
                    )
                  else
                    AnimationSwitchWidget(
                      first: _elementField(
                        title: 'pinCode.comeUp'.tr(),
                        pinCode: store.pinCode,
                        isLoading: store.startAnimation,
                      ),
                      second: _elementField(
                        title: 'pinCode.repeat'.tr(),
                        pinCode: store.pinCode,
                        isLoading: store.startAnimation,
                        activateAnimation: true,
                      ),
                      enabled: store.startSwitch,
                    ),
                  if (store.attempts != 0)
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        '${'pinCode.attempts_left'.tr()}: ${3 - store.attempts}',
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
                                store.signIn();
                              }
                            },
                          ),
                        KeyboardButton(
                          child: SvgPicture.asset(
                            store.isFaceId
                                ? Images.faceIdIcon
                                : Images.biometricIcon,
                            color: store.canBiometrics
                                ? AppColor.enabledButton
                                : Colors.transparent,
                            width: 30,
                            height: 30,
                          ),
                          onTab: () async {
                            if (store.canBiometrics) {
                              HapticFeedback.lightImpact();
                              await store.biometricScan();
                            }
                          },
                          hide: !store.canBiometrics,
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
      ),
    );
  }

  Widget _elementField({
    required String title,
    required String pinCode,
    required bool isLoading,
    bool activateAnimation = false,
  }) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xff353C47),
            ),
          ),
        ),
        if (activateAnimation)
          Container(
            height: 50,
            margin: const EdgeInsets.only(top: 16.0),
            child: AnimationCompression(
              first: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: PasswordField(
                  animationController: animationController,
                  pinCode: pinCode,
                  haveError: store.errorMessage != null,
                ),
              ),
              second: const SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
              enabled: isLoading,
            ),
          )
        else
          Container(
            height: 50,
            margin: const EdgeInsets.only(top: 16.0),
            child: PasswordField(
              animationController: animationController,
              pinCode: pinCode,
              haveError: store.errorMessage != null,
            ),
          ),
      ],
    );
  }
}

class PasswordField extends StatefulWidget {
  final AnimationController? animationController;
  final String pinCode;
  final bool haveError;

  const PasswordField({
    Key? key,
    required this.animationController,
    required this.pinCode,
    required this.haveError,
  }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (context, child) {
        final sineValue = sin(4 * 2 * pi * widget.animationController!.value);
        return Transform.translate(
          offset: widget.haveError ? Offset(sineValue * 10, 0) : Offset.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 1; i < 5; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 10,
                  width: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 7.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.pinCode.length >= i
                        ? AppColor.enabledButton
                        : const Color(0xffE9EDF2),
                  ),
                  child: AnimationColor(
                    duration: const Duration(milliseconds: 350),
                    width: 10,
                    height: 10,
                    startColor: Colors.transparent,
                    endColor: Colors.red,
                    enabled: widget.haveError,
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}

class KeyboardButton extends StatelessWidget {
  final Widget child;
  final Function()? onTab;
  final bool hide;

  const KeyboardButton({
    Key? key,
    required this.child,
    required this.onTab,
    this.hide = false,
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
          color: hide ? Colors.white : const Color(0xffF7F8FA),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
