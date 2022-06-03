// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_role_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SignUpRoleStore on SignUpRoleStoreBase, Store {
  Computed<bool>? _$canAgreeRoleComputed;

  @override
  bool get canAgreeRole =>
      (_$canAgreeRoleComputed ??= Computed<bool>(() => super.canAgreeRole,
              name: 'SignUpRoleStoreBase.canAgreeRole'))
          .value;

  final _$roleAtom = Atom(name: 'SignUpRoleStoreBase.role');

  @override
  UserRole get role {
    _$roleAtom.reportRead();
    return super.role;
  }

  @override
  set role(UserRole value) {
    _$roleAtom.reportWrite(value, super.role, () {
      super.role = value;
    });
  }

  final _$privacyPolicyAtom = Atom(name: 'SignUpRoleStoreBase.privacyPolicy');

  @override
  bool get privacyPolicy {
    _$privacyPolicyAtom.reportRead();
    return super.privacyPolicy;
  }

  @override
  set privacyPolicy(bool value) {
    _$privacyPolicyAtom.reportWrite(value, super.privacyPolicy, () {
      super.privacyPolicy = value;
    });
  }

  final _$termsConditionsAtom =
      Atom(name: 'SignUpRoleStoreBase.termsConditions');

  @override
  bool get termsConditions {
    _$termsConditionsAtom.reportRead();
    return super.termsConditions;
  }

  @override
  set termsConditions(bool value) {
    _$termsConditionsAtom.reportWrite(value, super.termsConditions, () {
      super.termsConditions = value;
    });
  }

  final _$amlCtfPolicyAtom = Atom(name: 'SignUpRoleStoreBase.amlCtfPolicy');

  @override
  bool get amlCtfPolicy {
    _$amlCtfPolicyAtom.reportRead();
    return super.amlCtfPolicy;
  }

  @override
  set amlCtfPolicy(bool value) {
    _$amlCtfPolicyAtom.reportWrite(value, super.amlCtfPolicy, () {
      super.amlCtfPolicy = value;
    });
  }

  final _$SignUpRoleStoreBaseActionController =
      ActionController(name: 'SignUpRoleStoreBase');

  @override
  dynamic setRole(UserRole value) {
    final _$actionInfo = _$SignUpRoleStoreBaseActionController.startAction(
        name: 'SignUpRoleStoreBase.setRole');
    try {
      return super.setRole(value);
    } finally {
      _$SignUpRoleStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPrivacyPolicy(bool value) {
    final _$actionInfo = _$SignUpRoleStoreBaseActionController.startAction(
        name: 'SignUpRoleStoreBase.setPrivacyPolicy');
    try {
      return super.setPrivacyPolicy(value);
    } finally {
      _$SignUpRoleStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setTermsConditions(bool value) {
    final _$actionInfo = _$SignUpRoleStoreBaseActionController.startAction(
        name: 'SignUpRoleStoreBase.setTermsConditions');
    try {
      return super.setTermsConditions(value);
    } finally {
      _$SignUpRoleStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAmlCtfPolicy(bool value) {
    final _$actionInfo = _$SignUpRoleStoreBaseActionController.startAction(
        name: 'SignUpRoleStoreBase.setAmlCtfPolicy');
    try {
      return super.setAmlCtfPolicy(value);
    } finally {
      _$SignUpRoleStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
role: ${role},
privacyPolicy: ${privacyPolicy},
termsConditions: ${termsConditions},
amlCtfPolicy: ${amlCtfPolicy},
canAgreeRole: ${canAgreeRole}
    ''';
  }
}
