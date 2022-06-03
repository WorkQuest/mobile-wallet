// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginStore on LoginStoreBase, Store {
  Computed<bool>? _$statusButtonComputed;

  @override
  bool get statusButton =>
      (_$statusButtonComputed ??= Computed<bool>(() => super.statusButton,
              name: 'LoginStoreBase.statusButton'))
          .value;

  final _$mnemonicAtom = Atom(name: 'LoginStoreBase.mnemonic');

  @override
  String get mnemonic {
    _$mnemonicAtom.reportRead();
    return super.mnemonic;
  }

  @override
  set mnemonic(String value) {
    _$mnemonicAtom.reportWrite(value, super.mnemonic, () {
      super.mnemonic = value;
    });
  }

  final _$loginAsyncAction = AsyncAction('LoginStoreBase.login');

  @override
  Future login(String mnemonic) {
    return _$loginAsyncAction.run(() => super.login(mnemonic));
  }

  final _$LoginStoreBaseActionController =
      ActionController(name: 'LoginStoreBase');

  @override
  dynamic setMnemonic(String value) {
    final _$actionInfo = _$LoginStoreBaseActionController.startAction(
        name: 'LoginStoreBase.setMnemonic');
    try {
      return super.setMnemonic(value);
    } finally {
      _$LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
mnemonic: ${mnemonic},
statusButton: ${statusButton}
    ''';
  }
}
