import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:workquest_wallet_app/page_router.dart';
import 'package:workquest_wallet_app/ui/sign_up_page/sign_up/sign_up_page.dart';
import 'package:workquest_wallet_app/utils/alert_dialog.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/default_textfield.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';
import 'package:workquest_wallet_app/widgets/observer_consumer.dart';

import 'mobx/sign_up_confirm_store.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

class SignUpConfirm extends StatefulWidget {
  final String email;

  const SignUpConfirm({Key? key, required this.email}) : super(key: key);

  @override
  _SignUpConfirmState createState() => _SignUpConfirmState();
}

class _SignUpConfirmState extends State<SignUpConfirm> {
  SignUpConfirmStore store = SignUpConfirmStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(
        title: 'meta.back'.tr(),
        titleCenter: false,
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
                Text(
                  'registration.emailConfirmTitle'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
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
                      PageRouter.pushNewReplacementRoute(context, const SignUpPage());
                    },
                    store: store,
                    child: DefaultButton(
                      onPressed: store.canConfirm ? () {
                        AlertDialogUtils.showLoadingDialog(context);
                        store.confirm();
                      } : null,
                      title: 'meta.submit'.tr(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Expanded(child: Container()),
                RichText(
                  textDirection: TextDirection.ltr,
                  text: const TextSpan(children: [
                    TextSpan(
                      text: 'Didn\'t get code?',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                    TextSpan(
                      text: ' Change email',
                      style: TextStyle(fontSize: 16.0, color: Colors.blue),
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
