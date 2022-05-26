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
  bool startSwitch = false;

  @observable
  bool startAnimation = false;

  @observable
  StatePinCode statePin = StatePinCode.check;

  @action
  init() async {
    pinCode = '';
    attempts = 0;
    canBiometrics = false;
    statePin = StatePinCode.check;
    final value = await Storage.read(StorageKeys.pinCode.toString());
    if (value != null && value.isNotEmpty) {
      statePin = StatePinCode.check;
      final auth = LocalAuthentication();
      canBiometrics = await auth.canCheckBiometrics;
      biometricScan();
    } else {
      statePin = StatePinCode.create;
    }
  }

  @action
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
        await Future.delayed(const Duration(milliseconds: 350));
        errorMessage = null;
      }
    } catch (e) {
      print(e);
      onError("PIN code is not suitable");
      await Future.delayed(const Duration(milliseconds: 350));
      errorMessage = null;
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
        startAnimation = true;
        await Future.delayed(const Duration(seconds: 2));
        statePin = StatePinCode.check;
        onSuccess(StatePinCode.success);
        return;
      }
      switch(statePin) {
        case StatePinCode.create:
          newPinCode = pinCode;
          pinCode = '';
          statePin = StatePinCode.repeat;
          onSuccess(StatePinCode.repeat);
          startSwitch = true;
          return;
        case StatePinCode.repeat:
          print('newPinCode: $newPinCode');
          print('pinCode: $pinCode');
          if (newPinCode == pinCode) {
            startAnimation = true;
            await Future.delayed(const Duration(seconds: 2));
            await Storage.write(StorageKeys.pinCode.toString(), pinCode);
            onSuccess(StatePinCode.success);
          } else {
            attempts++;
            if (attempts == 3) {
              statePin = StatePinCode.toLogin;
              onSuccess(StatePinCode.toLogin);
            } else {
              pinCode = '';
              onError("PIN code is not suitable $attempts");
              await Future.delayed(const Duration(milliseconds: 350));
              errorMessage = null;
            }
          }
          break;
        case StatePinCode.check:
          final value = await Storage.read(StorageKeys.pinCode.toString());
          if (value == pinCode) {
            startAnimation = true;
            await Future.delayed(const Duration(seconds: 2));
            onSuccess(StatePinCode.success);
          } else {
            attempts++;
            if (attempts == 3) {
              statePin = StatePinCode.toLogin;
              onSuccess(StatePinCode.toLogin);
            } else {
              pinCode = '';
              onError("PIN code is not suitable");
              await Future.delayed(const Duration(milliseconds: 350));
              errorMessage = null;
            }
          }
          break;
        case StatePinCode.toLogin:
        // TODO: Handle this case.
          break;
        case StatePinCode.success:
        // TODO: Handle this case.
          break;
      }
    } catch (e) {
      onError(e.toString());
    }
  }
}

enum StatePinCode { create, repeat, check, toLogin, success }


