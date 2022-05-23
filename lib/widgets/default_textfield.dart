import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workquest_wallet_app/constants.dart';

class DefaultTextField extends StatefulWidget {
  final TextEditingController controller;
  final Widget? suffixIcon;
  final Widget? prefitIcon;
  final String hint;
  final bool isPassword;
  final bool enableDispose;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  final Function(String)? onChanged;

  const DefaultTextField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.suffixIcon,
    required this.inputFormatters,
    this.validator,
    this.keyboardType,
    this.enableDispose = true,
    this.onChanged,
    this.prefitIcon,
    this.isPassword = false,
  }) : super(key: key);

  @override
  State<DefaultTextField> createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  late bool _visiblePassword;

  @override
  void initState() {
    super.initState();
    _visiblePassword = !widget.isPassword;
    widget.controller.addListener(() {
      if (widget.keyboardType == TextInputType.name) {
        final result = widget.controller.value.text.isEmpty ? '' : '${_upperFirst(
            widget.controller.text)}';
        widget.controller.value = widget.controller.value.copyWith(text: result);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (widget.enableDispose) {
      widget.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      validator: widget.validator,
      obscureText: !_visiblePassword,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor:
        widget.controller.text.isEmpty ? AppColor.disabledButton : Colors.white,
        hintText: widget.hint,
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
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _visiblePassword ? Icons.visibility : Icons.visibility_off,
            color: _visiblePassword ? Theme
                .of(context)
                .primaryColorDark : Colors.grey,
            size: 20.0,
          ),
          padding: const EdgeInsets.only(right: 8.0),
          splashRadius: 0.1,
          onPressed: () {
            setState(() {
              _visiblePassword = !_visiblePassword;
            });
          },
        )
            : widget.suffixIcon,
        prefixIcon: widget.prefitIcon,
      ),
    );
  }

  String? _upperFirst(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }
}
