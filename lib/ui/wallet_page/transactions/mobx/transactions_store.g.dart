// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TransactionsStore on TransactionsStoreBase, Store {
  final _$transactionsAtom = Atom(name: 'TransactionsStoreBase.transactions');

  @override
  ObservableList<ItemTransaction> get transactions {
    _$transactionsAtom.reportRead();
    return super.transactions;
  }

  @override
  set transactions(ObservableList<ItemTransaction> value) {
    _$transactionsAtom.reportWrite(value, super.transactions, () {
      super.transactions = value;
    });
  }

  final _$getTransactionsAsyncAction =
      AsyncAction('TransactionsStoreBase.getTransactions');

  @override
  Future getTransactions() {
    return _$getTransactionsAsyncAction.run(() => super.getTransactions());
  }

  @override
  String toString() {
    return '''
transactions: ${transactions}
    ''';
  }
}
