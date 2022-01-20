import 'package:local_auth/local_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/utils/storage.dart';

part 'pin_code_store.g.dart';

class PinCodeStore = PinCodeStoreBase with _$PinCodeStore;

abstract class PinCodeStoreBase extends IStore<StatePinCode> with Store {

  @observable
  String pinCode = '';

  @observable
  String newPinCode = '';

  @observable
  int attempts = 0;

  @observable
  bool canBiometrics = false;

  @observable
  StatePinCode statePin = StatePinCode.check;

  @action
  init() async {
    pinCode = '';
    attempts = 0;
    canBiometrics = false;
    statePin = StatePinCode.check;
    final value = await Storage.read(Storage.pinCodeKey);
    if (value != null && value.isNotEmpty) {
      statePin = StatePinCode.check;
      final auth = LocalAuthentication();
      canBiometrics = await auth.canCheckBiometrics;
    } else {
      statePin = StatePinCode.create;
    }
  }

  Future biometricScan() async {
    final auth = LocalAuthentication();
    try {
      bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Login authorization',
          biometricOnly: true
      );
      if (didAuthenticate) {
        signIn(isBiometric: true);
      } else {
        onError("PIN code is not suitable");
      }
    } catch (e) {
      print(e);
      onError("PIN code is not suitable");
    }
  }

  @action
  inputPin(int pin){
    if (pinCode.length < 4) pinCode += pin.toString();
  }

  @action
  removePin() {
    if (pinCode.isNotEmpty) pinCode = pinCode.substring(0, pinCode.length - 1);
  }

  @action
  signIn({bool isBiometric = false}) async {
    onLoading();
    try {
      if (isBiometric) {
        statePin = StatePinCode.success;
        onSuccess(StatePinCode.success);
        return;
      }
      if (statePin == StatePinCode.create) {
        newPinCode = pinCode;
        pinCode = '';
        statePin = StatePinCode.repeat;
        onSuccess(StatePinCode.repeat);
        return;
      } else if (statePin == StatePinCode.repeat) {
        if (newPinCode == pinCode) {
          await Storage.write(Storage.pinCodeKey, pinCode);
          statePin = StatePinCode.success;
          onSuccess(StatePinCode.success);
        } else {
          attempts++;
          if (attempts == 3) {
            statePin = StatePinCode.toLogin;
            onSuccess(StatePinCode.toLogin);
          } else {
            pinCode = '';
            onError("PIN code is not suitable $attempts");
          }
        }
      } else {
        final value = await Storage.read(Storage.pinCodeKey);
        if (value == pinCode) {
          statePin = StatePinCode.success;
          onSuccess(StatePinCode.success);
        } else {
          attempts++;
          if (attempts == 3) {
            statePin = StatePinCode.toLogin;
            onSuccess(StatePinCode.toLogin);
          } else {
            pinCode = '';
            onError("PIN code is not suitable");
          }
        }
      }
    } catch (e) {
      onError(e.toString());
    }
  }
}

enum StatePinCode { create, repeat, check, toLogin, success }


