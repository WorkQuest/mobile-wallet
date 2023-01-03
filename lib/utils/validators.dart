import 'package:easy_localization/easy_localization.dart';
import 'package:workquest_wallet_app/constants.dart';

class Validators {
  static String? transferAddress(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return 'errors.fieldEmpty'.tr();
      }
      try {
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
      } catch (e) {
        return 'errors.incorrectFormat'.tr();
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
    return null;
  }

  static String? loginMnemonic(String value) {
    if (value.length <= 24) {
      return "errors.smallNumberWords".tr();
    }
    if (value.split(' ').toList().length < 12) {
      return "errors.incorrectMnemonicFormat".tr();
    }
    return null;
  }

  static String? swapAmount(String? value, double? maxAmount) {
    if (value == null) {
      return "errors.fieldEmpty".tr();
    }
    try {
      final val = double.parse(value);
      if (val < 5.0) {
        return 'swap.minimum'.tr();
      }
      if (val > 100.0) {
        return 'swap.maximum'.tr();
      }
      if (maxAmount != null) {
        if (maxAmount < val) {
          return 'errors.higherMaxAmount'.tr();
        }
      }
    } catch (e) {
      return "errors.fieldEmpty".tr();
    }
    return null;
  }
}
