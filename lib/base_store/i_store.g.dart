// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'i_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$IStore<T> on _IStore<T>, Store {
  Computed<bool>? _$isSuccessComputed;

  @override
  bool get isSuccess => (_$isSuccessComputed ??=
          Computed<bool>(() => super.isSuccess, name: '_IStore.isSuccess'))
      .value;

  late final _$isLoadingAtom =
      Atom(name: '_IStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$successDataAtom =
      Atom(name: '_IStore.successData', context: context);

  @override
  T? get successData {
    _$successDataAtom.reportRead();
    return super.successData;
  }

  @override
  set successData(T? value) {
    _$successDataAtom.reportWrite(value, super.successData, () {
      super.successData = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_IStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
successData: ${successData},
errorMessage: ${errorMessage},
isSuccess: ${isSuccess}
    ''';
  }
}
