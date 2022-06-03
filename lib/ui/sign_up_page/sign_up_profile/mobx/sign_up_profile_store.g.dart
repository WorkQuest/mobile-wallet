// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SignUpProfileStore on SignUpProfileStoreBase, Store {
  final _$emailAtom = Atom(name: 'SignUpProfileStoreBase.email');

  @override
  TextEditingController get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(TextEditingController value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  final _$firstNameAtom = Atom(name: 'SignUpProfileStoreBase.firstName');

  @override
  TextEditingController get firstName {
    _$firstNameAtom.reportRead();
    return super.firstName;
  }

  @override
  set firstName(TextEditingController value) {
    _$firstNameAtom.reportWrite(value, super.firstName, () {
      super.firstName = value;
    });
  }

  final _$lastNameAtom = Atom(name: 'SignUpProfileStoreBase.lastName');

  @override
  TextEditingController get lastName {
    _$lastNameAtom.reportRead();
    return super.lastName;
  }

  @override
  set lastName(TextEditingController value) {
    _$lastNameAtom.reportWrite(value, super.lastName, () {
      super.lastName = value;
    });
  }

  final _$passwordAtom = Atom(name: 'SignUpProfileStoreBase.password');

  @override
  TextEditingController get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(TextEditingController value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  final _$passwordConfirmAtom =
      Atom(name: 'SignUpProfileStoreBase.passwordConfirm');

  @override
  TextEditingController get passwordConfirm {
    _$passwordConfirmAtom.reportRead();
    return super.passwordConfirm;
  }

  @override
  set passwordConfirm(TextEditingController value) {
    _$passwordConfirmAtom.reportWrite(value, super.passwordConfirm, () {
      super.passwordConfirm = value;
    });
  }

  final _$registerAsyncAction = AsyncAction('SignUpProfileStoreBase.register');

  @override
  Future register() {
    return _$registerAsyncAction.run(() => super.register());
  }

  @override
  String toString() {
    return '''
email: ${email},
firstName: ${firstName},
lastName: ${lastName},
password: ${password},
passwordConfirm: ${passwordConfirm}
    ''';
  }
}
