// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_code_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PinCodeStore on PinCodeStoreBase, Store {
  late final _$pinCodeAtom =
      Atom(name: 'PinCodeStoreBase.pinCode', context: context);

  @override
  String get pinCode {
    _$pinCodeAtom.reportRead();
    return super.pinCode;
  }

  @override
  set pinCode(String value) {
    _$pinCodeAtom.reportWrite(value, super.pinCode, () {
      super.pinCode = value;
    });
  }

  late final _$newPinCodeAtom =
      Atom(name: 'PinCodeStoreBase.newPinCode', context: context);

  @override
  String get newPinCode {
    _$newPinCodeAtom.reportRead();
    return super.newPinCode;
  }

  @override
  set newPinCode(String value) {
    _$newPinCodeAtom.reportWrite(value, super.newPinCode, () {
      super.newPinCode = value;
    });
  }

  late final _$attemptsAtom =
      Atom(name: 'PinCodeStoreBase.attempts', context: context);

  @override
  int get attempts {
    _$attemptsAtom.reportRead();
    return super.attempts;
  }

  @override
  set attempts(int value) {
    _$attemptsAtom.reportWrite(value, super.attempts, () {
      super.attempts = value;
    });
  }

  late final _$canBiometricsAtom =
      Atom(name: 'PinCodeStoreBase.canBiometrics', context: context);

  @override
  bool get canBiometrics {
    _$canBiometricsAtom.reportRead();
    return super.canBiometrics;
  }

  @override
  set canBiometrics(bool value) {
    _$canBiometricsAtom.reportWrite(value, super.canBiometrics, () {
      super.canBiometrics = value;
    });
  }

  late final _$startSwitchAtom =
      Atom(name: 'PinCodeStoreBase.startSwitch', context: context);

  @override
  bool get startSwitch {
    _$startSwitchAtom.reportRead();
    return super.startSwitch;
  }

  @override
  set startSwitch(bool value) {
    _$startSwitchAtom.reportWrite(value, super.startSwitch, () {
      super.startSwitch = value;
    });
  }

  late final _$startAnimationAtom =
      Atom(name: 'PinCodeStoreBase.startAnimation', context: context);

  @override
  bool get startAnimation {
    _$startAnimationAtom.reportRead();
    return super.startAnimation;
  }

  @override
  set startAnimation(bool value) {
    _$startAnimationAtom.reportWrite(value, super.startAnimation, () {
      super.startAnimation = value;
    });
  }

  late final _$statePinAtom =
      Atom(name: 'PinCodeStoreBase.statePin', context: context);

  @override
  StatePinCode get statePin {
    _$statePinAtom.reportRead();
    return super.statePin;
  }

  @override
  set statePin(StatePinCode value) {
    _$statePinAtom.reportWrite(value, super.statePin, () {
      super.statePin = value;
    });
  }

  late final _$isFaceIdAtom =
      Atom(name: 'PinCodeStoreBase.isFaceId', context: context);

  @override
  bool get isFaceId {
    _$isFaceIdAtom.reportRead();
    return super.isFaceId;
  }

  @override
  set isFaceId(bool value) {
    _$isFaceIdAtom.reportWrite(value, super.isFaceId, () {
      super.isFaceId = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('PinCodeStoreBase.init', context: context);

  @override
  Future init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$biometricScanAsyncAction =
      AsyncAction('PinCodeStoreBase.biometricScan', context: context);

  @override
  Future<dynamic> biometricScan() {
    return _$biometricScanAsyncAction.run(() => super.biometricScan());
  }

  late final _$signInAsyncAction =
      AsyncAction('PinCodeStoreBase.signIn', context: context);

  @override
  Future signIn({bool isBiometric = false}) {
    return _$signInAsyncAction
        .run(() => super.signIn(isBiometric: isBiometric));
  }

  late final _$PinCodeStoreBaseActionController =
      ActionController(name: 'PinCodeStoreBase', context: context);

  @override
  dynamic inputPin(int pin) {
    final _$actionInfo = _$PinCodeStoreBaseActionController.startAction(
        name: 'PinCodeStoreBase.inputPin');
    try {
      return super.inputPin(pin);
    } finally {
      _$PinCodeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removePin() {
    final _$actionInfo = _$PinCodeStoreBaseActionController.startAction(
        name: 'PinCodeStoreBase.removePin');
    try {
      return super.removePin();
    } finally {
      _$PinCodeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pinCode: ${pinCode},
newPinCode: ${newPinCode},
attempts: ${attempts},
canBiometrics: ${canBiometrics},
startSwitch: ${startSwitch},
startAnimation: ${startAnimation},
statePin: ${statePin},
isFaceId: ${isFaceId}
    ''';
  }
}
