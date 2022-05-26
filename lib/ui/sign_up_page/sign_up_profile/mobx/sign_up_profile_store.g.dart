// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SignUpProfileStore on SignUpProfileStoreBase, Store {
  late final _$emailAtom =
      Atom(name: 'SignUpProfileStoreBase.email', context: context);

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

  late final _$firstNameAtom =
      Atom(name: 'SignUpProfileStoreBase.firstName', context: context);

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

  late final _$lastNameAtom =
      Atom(name: 'SignUpProfileStoreBase.lastName', context: context);

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

  late final _$passwordAtom =
      Atom(name: 'SignUpProfileStoreBase.password', context: context);

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

  late final _$passwordConfirmAtom =
      Atom(name: 'SignUpProfileStoreBase.passwordConfirm', context: context);

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

  late final _$registerAsyncAction =
      AsyncAction('SignUpProfileStoreBase.register', context: context);

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
