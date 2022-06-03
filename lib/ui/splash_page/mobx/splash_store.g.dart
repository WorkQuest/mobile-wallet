// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SplashStore on SplashStoreBase, Store {
  final _$isLoginPageAtom = Atom(name: 'SplashStoreBase.isLoginPage');

  @override
  bool? get isLoginPage {
    _$isLoginPageAtom.reportRead();
    return super.isLoginPage;
  }

  @override
  set isLoginPage(bool? value) {
    _$isLoginPageAtom.reportWrite(value, super.isLoginPage, () {
      super.isLoginPage = value;
    });
  }

  final _$signAsyncAction = AsyncAction('SplashStoreBase.sign');

  @override
  Future sign() {
    return _$signAsyncAction.run(() => super.sign());
  }

  @override
  String toString() {
    return '''
isLoginPage: ${isLoginPage}
    ''';
  }
}
