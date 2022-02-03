// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_confirm_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SignUpConfirmStore on SignUpConfirmStoreBase, Store {
  final _$codeAtom = Atom(name: 'SignUpConfirmStoreBase.code');

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

  final _$canConfirmAtom = Atom(name: 'SignUpConfirmStoreBase.canConfirm');

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

  final _$confirmAsyncAction = AsyncAction('SignUpConfirmStoreBase.confirm');

  @override
  Future confirm(String role) {
    return _$confirmAsyncAction.run(() => super.confirm(role));
  }

  @override
  String toString() {
    return '''
code: ${code},
canConfirm: ${canConfirm}
    ''';
  }
}
