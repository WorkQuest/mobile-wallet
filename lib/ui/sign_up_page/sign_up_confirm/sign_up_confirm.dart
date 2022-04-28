import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:workquest_wallet_app/http/api.dart';
import 'package:workquest_wallet_app/page_router.dart';
import 'package:workquest_wallet_app/utils/alert_dialog.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/default_textfield.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';
import 'package:workquest_wallet_app/widgets/observer_consumer.dart';

import '../../../constants.dart';
import 'mobx/sign_up_confirm_store.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

class SignUpConfirm extends StatefulWidget {
  final String email;
  final String role;
  final Widget nextPage;

  const SignUpConfirm({
    Key? key,
    required this.email,
    required this.role,
    required this.nextPage,
  }) : super(key: key);

  @override
  _SignUpConfirmState createState() => _SignUpConfirmState();
}

class _SignUpConfirmState extends State<SignUpConfirm> {
  late SignUpConfirmStore store;

  @override
  void initState() {
    super.initState();
    store = GetIt.I.get<SignUpConfirmStore>();
    store.initTime(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return Future<bool>.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: DefaultAppBar(
          title: 'meta.back'.tr(),
          titleCenter: false,
          onPressed: () async {
            Navigator.pop(context, true);
          },
        ),
        body: Observer(
          builder: (_) => LayoutWithScroll(
            child: Padding(
              padding: _padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'registration.confirmYourEmail'.tr(),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'registration.emailConfirm'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.email,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Flexible(
                    child: Text(
                      '${'registration.emailConfirmTitle'.tr()} ${'registration.emailCheckSpam'.tr()}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (!Api.isRelease && widget.email.isNotEmpty)
                    _TimerWidget(
                      startTimer: () => store.startTimer(widget.email),
                      seconds: store.secondsCodeAgain,
                      isActiveTimer: store.timer != null && store.timer!.isActive,
                    ),
                  const SizedBox(
                    height: 40,
                  ),
                  DefaultTextField(
                    controller: store.code,
                    hint: "Code",
                    suffixIcon: null,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ObserverListener(
                      onFailure: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        return false;
                      },
                      onSuccess: () async {
                        Navigator.of(context, rootNavigator: true).pop();
                        await AlertDialogUtils.showSuccessDialog(context);
                        PageRouter.pushNewReplacementRoute(
                            context, widget.nextPage);
                      },
                      store: store,
                      child: DefaultButton(
                        onPressed: store.canConfirm
                            ? () {
                                AlertDialogUtils.showLoadingDialog(context);
                                store.confirm(widget.role);
                              }
                            : null,
                        title: 'meta.submit'.tr(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Expanded(child: Container()),
                  // RichText(
                  //   textDirection: TextDirection.ltr,
                  //   text: TextSpan(
                  //     children: [
                  //       TextSpan(
                  //         text: 'pinCode.not_get_code'.tr(),
                  //         style: const TextStyle(fontSize: 16.0, color: Colors.black),
                  //       ),
                  //       TextSpan(
                  //         text: ' ${'pinCode.change_email'.tr()}',
                  //         style: const TextStyle(fontSize: 16.0, color: Colors.blue),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimerWidget extends StatelessWidget {
  final Function() startTimer;
  final bool isActiveTimer;
  final int seconds;

  const _TimerWidget({
    Key? key,
    required this.isActiveTimer,
    required this.startTimer,
    required this.seconds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(
            'Send again',
            style: TextStyle(
              fontSize: 14,
              color: isActiveTimer
                  ? AppColor.disabledText
                  : AppColor.enabledButton,
            ),
          ),
          onPressed: isActiveTimer ? null : startTimer,
        ),
        const SizedBox(
          width: 10,
        ),
        if (isActiveTimer)
          Text(
            convertSecondToLine(seconds),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
      ],
    );
  }

  String convertSecondToLine(int seconds) {
    int min = seconds ~/ 60;
    int sec = seconds - (min * 60);
    return '${min < 10 ? '0$min' : '$min'}:${sec < 10 ? '0$sec' : '$sec'}';
  }
}
