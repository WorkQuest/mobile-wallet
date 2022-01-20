// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_code_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PinCodeStore on PinCodeStoreBase, Store {
  final _$pinCodeAtom = Atom(name: 'PinCodeStoreBase.pinCode');

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

  final _$newPinCodeAtom = Atom(name: 'PinCodeStoreBase.newPinCode');

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

  final _$attemptsAtom = Atom(name: 'PinCodeStoreBase.attempts');

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

  final _$canBiometricsAtom = Atom(name: 'PinCodeStoreBase.canBiometrics');

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

  final _$statePinAtom = Atom(name: 'PinCodeStoreBase.statePin');

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

  final _$initAsyncAction = AsyncAction('PinCodeStoreBase.init');

  @override
  Future init() {
    return _$initAsyncAction.run(() => super.init());
  }

  final _$signInAsyncAction = AsyncAction('PinCodeStoreBase.signIn');

  @override
  Future signIn({bool isBiometric = false}) {
    return _$signInAsyncAction
        .run(() => super.signIn(isBiometric: isBiometric));
  }

  final _$PinCodeStoreBaseActionController =
      ActionController(name: 'PinCodeStoreBase');

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
statePin: ${statePin}
    ''';
  }
}
