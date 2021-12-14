import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/default_textfield.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';

import '../../constants.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

final _emailRegExp = RegExp(
  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
);

final _firstNameRegExp = RegExp(r'^[a-zA-Z]+$');

final _passwordRegExp = RegExp(r'^[а-яА-Я]');

class SignUpCreateProfile extends StatefulWidget {
  const SignUpCreateProfile({Key? key}) : super(key: key);

  @override
  _SignUpCreateProfileState createState() => _SignUpCreateProfileState();
}

class _SignUpCreateProfileState extends State<SignUpCreateProfile> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repeatPasswordController = TextEditingController();

  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(() {
      setState(() {});
    });
    _lastNameController.addListener(() {
      setState(() {});
    });
    _emailController.addListener(() {
      setState(() {});
    });
    _passwordController.addListener(() {
      setState(() {});
    });
    _repeatPasswordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const DefaultAppBar(
        title: 'Back',
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
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                DefaultTextField(
                  controller: _firstNameController,
                  hint: 'First name',
                  validator: (value) {
                    if (_firstNameController.text.isEmpty) {
                      return "Field is empty";
                    }
                    if (_firstNameController.text.length < 4) {
                      return "Incorrect format";
                    }
                    if (!_firstNameRegExp.hasMatch(_firstNameController.text)) {
                      return "Incorrect format";
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
                  inputFormatters: [LengthLimitingTextInputFormatter(25)],
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultTextField(
                  controller: _lastNameController,
                  hint: 'Last name',
                  validator: (value) {
                    if (_lastNameController.text.isEmpty) {
                      return "Field is empty";
                    }
                    if (_lastNameController.text.length < 4) {
                      return "Incorrect format";
                    }
                    if (!_firstNameRegExp.hasMatch(_lastNameController.text)) {
                      return "Incorrect format";
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
                  inputFormatters: [LengthLimitingTextInputFormatter(25)],
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultTextField(
                  controller: _emailController,
                  hint: 'Email',
                  validator: (value) {
                    if (_emailController.text.isEmpty) {
                      return "Field is empty";
                    }
                    if (_emailController.text.contains(" ")) {
                      return "Incorrect format";
                    }
                    if (!_emailRegExp.hasMatch(_emailController.text)) {
                      return "Incorrect format";
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
                  inputFormatters: [LengthLimitingTextInputFormatter(25)],
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultTextField(
                  controller: _passwordController,
                  hint: 'Password',
                  obscureText: true,
                  validator: (value) {
                    if (_passwordController.text.isEmpty) {
                      return "Field is empty";
                    }
                    if (_passwordController.text.length < 4) {
                      return "Incorrect format";
                    }
                    if (_passwordRegExp.hasMatch(_passwordController.text)) {
                      return "Incorrect format";
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
                  controller: _repeatPasswordController,
                  hint: 'Repeat password',
                  obscureText: true,
                  validator: (value) {
                    if (_repeatPasswordController.text.isEmpty) {
                      return "Field is empty";
                    }
                    if (_repeatPasswordController.text !=
                        _passwordController.text) {
                      return "Passwords don't match";
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
                SizedBox(
                  width: double.infinity,
                  child: DefaultButton(
                    title: 'Generate address',
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        print('Generate address');
                      }

                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(child: Container()),
                Row(
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_key.currentState!.validate()) {
                          print('validate');
                        }
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
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
