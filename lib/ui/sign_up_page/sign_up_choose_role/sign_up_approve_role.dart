import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/page_router.dart';
import 'package:workquest_wallet_app/ui/pin_code_page/pin_code_page.dart';
import 'package:workquest_wallet_app/ui/sign_up_page/sign_up_confirm/sign_up_confirm.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';

import 'mobx/sign_up_role_store.dart';

class SignUpApproveRole extends StatefulWidget {
  final bool isWorker;
  final Widget child;
  final SignUpRoleStore store;

  const SignUpApproveRole({
    Key? key,
    required this.isWorker,
    required this.child,
    required this.store,
  }) : super(key: key);

  @override
  _SignUpApproveRoleState createState() => _SignUpApproveRoleState();
}

class _SignUpApproveRoleState extends State<SignUpApproveRole> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'Back',
        titleCenter: false,
      ),
      body: Observer(
        builder: (_) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                'You role is ${widget.store.role == UserRole.worker ? 'worker' : 'employer'} right?',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              widget.child,
              const SizedBox(
                height: 30,
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: widget.store.privacyPolicy,
                onChanged: (value) => widget.store.setPrivacyPolicy(value!),
                controlAffinity: ListTileControlAffinity.leading,
                title: textWithLink(textLink: 'Privacy policy'),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: widget.store.termsConditions,
                onChanged: (value) => widget.store.setTermsConditions(value!),
                controlAffinity: ListTileControlAffinity.leading,
                title: textWithLink(textLink: 'Terms & Conditions'),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: widget.store.amlCtfPolicy,
                onChanged: (value) => widget.store.setAmlCtfPolicy(value!),
                controlAffinity: ListTileControlAffinity.leading,
                title: textWithLink(textLink: 'AML & CTF Policy'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Observer(
        builder: (_) => Padding(
          padding: EdgeInsets.only(
            right: 16.0,
            left: 16.0,
            bottom: 10 + MediaQuery.of(context).padding.bottom,
          ),
          child: SizedBox(
            width: double.infinity,
            child: DefaultButton(
              title: 'I agree',
              onPressed: widget.store.canAgreeRole
                  ? _onPressedAgree
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  void _onPressedAgree() {
    PageRouter.pushNewRoute(
      context,
      SignUpConfirm(
        nextPage: const PinCodePage(),
        email: '',
        role: widget.store.role == UserRole.worker ? 'worker' : 'employer',
      ),
    );
  }

  Widget textWithLink({required String textLink, String? link}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'I agree with ',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            textLink,
            style: const TextStyle(
              fontSize: 16,
              color: AppColor.enabledButton,
              decoration: TextDecoration.underline,
            ),
          ),
        )
      ],
    );
  }
}
