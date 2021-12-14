import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workquest_wallet_app/constants.dart';

class DefaultTextField extends StatelessWidget {
  final TextEditingController controller;
  final Widget? suffixIcon;
  final Widget? prefitIcon;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const DefaultTextField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.suffixIcon,
    required this.inputFormatters,
    this.validator,
    this.keyboardType,
    this.prefitIcon,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType ?? TextInputType.text,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor:
            controller.text.isEmpty ? AppColor.disabledButton : Colors.white,
        hintText: hint,
        focusColor: Colors.red,
        hoverColor: Colors.green,
        hintStyle: const TextStyle(
          fontSize: 16,
          color: AppColor.disabledText,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 12.5,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.blue,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(
            width: 1,
            color: AppColor.disabledButton,
            style: BorderStyle.solid,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(
            width: 1,
            color: AppColor.disabledButton,
            style: BorderStyle.solid,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.red,
            style: BorderStyle.solid,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.red,
            style: BorderStyle.solid,
          ),
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefitIcon,
      ),
    );
  }
}
