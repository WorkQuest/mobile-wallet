import 'package:easy_localization/easy_localization.dart';
import 'package:workquest_wallet_app/constants.dart';

class Validators {
  static String? transferAddress(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return 'errors.fieldEmpty'.tr();
      }
      final _isBech = value.substring(0, 2).toLowerCase() == 'wq';
      if (_isBech) {
        if (value.length != 41) {
          return "errors.invalidAddress".tr();
        }
        if (!RegExpFields.addressBech32RegExp.hasMatch(value)) {
          return "errors.invalidAddress".tr();
        }
      } else {
        if (value.length != 42) {
          return "errors.invalidAddress".tr();
        }
        if (!RegExpFields.addressRegExp.hasMatch(value)) {
          return "errors.invalidAddress".tr();
        }
      }
    }
    return null;
  }

  static String? transferAmount(String? value, double? maxAmount) {
    if (value == null) {
      return null;
    }
    if (value.isEmpty) {
      return 'errors.fieldEmpty'.tr();
    }
    try {
      final _value = double.parse(value);
      if (maxAmount != null) {
        if (_value > maxAmount) {
          return 'Max: $maxAmount';
        }
      }
    } catch (e) {
      return 'errors.incorrectFormat'.tr();
    }
  }
}