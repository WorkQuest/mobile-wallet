import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workquest_wallet_app/ui/sign_up_page/sign_up/sign_up_page.dart';
import 'package:workquest_wallet_app/ui/sign_up_page/sign_up_profile/mobx/sign_up_profile_store.dart';
import 'package:workquest_wallet_app/utils/alert_dialog.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/default_textfield.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';
import 'package:workquest_wallet_app/widgets/observer_consumer.dart';

import '../../../constants.dart';
import '../../../page_router.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);


class SignUpCreateProfile extends StatefulWidget {
  const SignUpCreateProfile({Key? key}) : super(key: key);

  @override
  _SignUpCreateProfileState createState() => _SignUpCreateProfileState();
}

class _SignUpCreateProfileState extends State<SignUpCreateProfile> {
  final _key = GlobalKey<FormState>();

  SignUpProfileStore store = SignUpProfileStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(
        title: 'meta.back'.tr(),
        titleCenter: false,
      ),
      body: Form(
        key: _key,
        child: Padding(
          padding: _padding,
          child: LayoutWithScroll(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'signIn.signUp'.tr(),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                DefaultTextField(
                  controller: store.firstName,
                  hint: 'labels.firstName'.tr(),
                  validator: (value) {
                    if (store.firstName.text.isEmpty) {
                      return "errors.fieldEmpty".tr();
                    }
                    if (store.firstName.text.length < 2) {
                      return "errors.incorrectFormat".tr();
                    }
                    return null;
                  },
                  prefitIcon: Padding(
                    padding: const EdgeInsets.only(
                      left: 19.0,
                      right: 14.0,
                      top: 14.0,
                      bottom: 13.0,
                    ),
                    child: SvgPicture.asset(Images.profileIcon),
                  ),
                  suffixIcon: null,
                  inputFormatters: null,
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultTextField(
                  controller: store.lastName,
                  hint: 'labels.lastName'.tr(),
                  validator: (value) {
                    if (store.lastName.text.isEmpty) {
                      return "errors.fieldEmpty".tr();
                    }
                    if (store.lastName.text.length < 2) {
                      return "errors.incorrectFormat".tr();
                    }
                    return null;
                  },
                  prefitIcon: Padding(
                    padding: const EdgeInsets.only(
                      left: 19.0,
                      right: 14.0,
                      top: 14.0,
                      bottom: 13.0,
                    ),
                    child: SvgPicture.asset(Images.profileIcon),
                  ),
                  suffixIcon: null,
                  inputFormatters: null,
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultTextField(
                  controller: store.email,
                  hint: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (store.email.text.isEmpty) {
                      return "errors.fieldEmpty".tr();
                    }
                    if (store.email.text.contains(" ")) {
                      return "errors.incorrectFormat".tr();
                    }
                    if (!RegExpFields.emailRegExp.hasMatch(store.email.text)) {
                      print('tester');
                      return "errors.incorrectFormat".tr();
                    }
                    return null;
                  },
                  prefitIcon: Padding(
                    padding: const EdgeInsets.only(
                      left: 17.0,
                      right: 12.0,
                      top: 15.0,
                      bottom: 15.0,
                    ),
                    child: SvgPicture.asset(Images.emailIcon),
                  ),
                  suffixIcon: null,
                  inputFormatters: null,
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultTextField(
                  controller: store.password,
                  hint: 'signUp.password'.tr(),
                  obscureText: true,
                  validator: (value) {
                    if (store.password.text.isEmpty) {
                      return "errors.fieldEmpty".tr();
                    }
                    if (store.password.text.length < 8) {
                      return "errors.incorrectFormat".tr();
                    }
                    if (RegExpFields.passwordRegExp.hasMatch(store.password.text)) {
                      return "errors.incorrectFormat".tr();
                    }
                    return null;
                  },
                  prefitIcon: Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 15.0,
                      top: 13.0,
                      bottom: 13.0,
                    ),
                    child: SvgPicture.asset(Images.passwordIcon),
                  ),
                  suffixIcon: null,
                  inputFormatters: [LengthLimitingTextInputFormatter(18)],
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultTextField(
                  controller: store.passwordConfirm,
                  hint: 'signUp.confirmPassword'.tr(),
                  obscureText: true,
                  validator: (value) {
                    if (store.passwordConfirm.text.isEmpty) {
                      return "errors.fieldEmpty".tr();
                    }
                    if (store.passwordConfirm.text != store.password.text) {
                      return "errors.passwordsNotMatch".tr();
                    }
                    return null;
                  },
                  prefitIcon: Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 15.0,
                      top: 13.0,
                      bottom: 13.0,
                    ),
                    child: SvgPicture.asset(Images.passwordIcon),
                  ),
                  suffixIcon: null,
                  inputFormatters: [LengthLimitingTextInputFormatter(18)],
                ),
                const SizedBox(
                  height: 30,
                ),
                ObserverListener(
                  store: store,
                  onFailure: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    return false;
                  },
                  onSuccess: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    await AlertDialogUtils.showSuccessDialog(context);
                    PageRouter.pushNewReplacementRoute(context, const SignUpPage());
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: DefaultButton(
                      title: 'signUp.generateAddress'.tr(),
                      onPressed: () async {
                        if (_key.currentState!.validate()) {
                          AlertDialogUtils.showLoadingDialog(context);
                          store.register();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(child: Container()),
                Row(
                  children: [
                    Text(
                      'signUp.haveAccount'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'signIn.title'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColor.enabledButton,
                        ),
                      ),
                    )
                  ],
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
