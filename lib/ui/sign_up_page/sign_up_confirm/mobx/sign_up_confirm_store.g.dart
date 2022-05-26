// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_confirm_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SignUpConfirmStore on SignUpConfirmStoreBase, Store {
  late final _$codeAtom =
      Atom(name: 'SignUpConfirmStoreBase.code', context: context);

  @override
  TextEditingController get code {
    _$codeAtom.reportRead();
    return super.code;
  }

  @override
  set code(TextEditingController value) {
    _$codeAtom.reportWrite(value, super.code, () {
      super.code = value;
    });
  }

  late final _$canConfirmAtom =
      Atom(name: 'SignUpConfirmStoreBase.canConfirm', context: context);

  @override
  bool get canConfirm {
    _$canConfirmAtom.reportRead();
    return super.canConfirm;
  }

  @override
  set canConfirm(bool value) {
    _$canConfirmAtom.reportWrite(value, super.canConfirm, () {
      super.canConfirm = value;
    });
  }

  late final _$timerAtom =
      Atom(name: 'SignUpConfirmStoreBase.timer', context: context);

  @override
  Timer? get timer {
    _$timerAtom.reportRead();
    return super.timer;
  }

  @override
  set timer(Timer? value) {
    _$timerAtom.reportWrite(value, super.timer, () {
      super.timer = value;
    });
  }

  late final _$secondsCodeAgainAtom =
      Atom(name: 'SignUpConfirmStoreBase.secondsCodeAgain', context: context);

  @override
  int get secondsCodeAgain {
    _$secondsCodeAgainAtom.reportRead();
    return super.secondsCodeAgain;
  }

  @override
  set secondsCodeAgain(int value) {
    _$secondsCodeAgainAtom.reportWrite(value, super.secondsCodeAgain, () {
      super.secondsCodeAgain = value;
    });
  }

  late final _$confirmAsyncAction =
      AsyncAction('SignUpConfirmStoreBase.confirm', context: context);

  @override
  Future confirm(String role) {
    return _$confirmAsyncAction.run(() => super.confirm(role));
  }

  late final _$startTimerAsyncAction =
      AsyncAction('SignUpConfirmStoreBase.startTimer', context: context);

  @override
  Future startTimer(String email) {
    return _$startTimerAsyncAction.run(() => super.startTimer(email));
  }

  late final _$SignUpConfirmStoreBaseActionController =
      ActionController(name: 'SignUpConfirmStoreBase', context: context);

  @override
  dynamic stopTimer() {
    final _$actionInfo = _$SignUpConfirmStoreBaseActionController.startAction(
        name: 'SignUpConfirmStoreBase.stopTimer');
    try {
      return super.stopTimer();
    } finally {
      _$SignUpConfirmStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
code: ${code},
canConfirm: ${canConfirm},
timer: ${timer},
secondsCodeAgain: ${secondsCodeAgain}
    ''';
  }
}
