// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_transfer_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConfirmTransferStore on ConfirmTransferStoreBase, Store {
  late final _$sendTransactionAsyncAction =
      AsyncAction('ConfirmTransferStoreBase.sendTransaction', context: context);

  @override
  Future sendTransaction(
      String addressTo, String amount, TokenSymbols typeCoin, Decimal fee) {
    return _$sendTransactionAsyncAction
        .run(() => super.sendTransaction(addressTo, amount, typeCoin, fee));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
