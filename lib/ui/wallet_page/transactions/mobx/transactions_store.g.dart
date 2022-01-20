// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TransactionsStore on TransactionsStoreBase, Store {
  final _$transactionsAtom = Atom(name: 'TransactionsStoreBase.transactions');

  @override
  ObservableList<Tx> get transactions {
    _$transactionsAtom.reportRead();
    return super.transactions;
  }

  @override
  set transactions(ObservableList<Tx> value) {
    _$transactionsAtom.reportWrite(value, super.transactions, () {
      super.transactions = value;
    });
  }

  final _$isMoreLoadingAtom = Atom(name: 'TransactionsStoreBase.isMoreLoading');

  @override
  bool get isMoreLoading {
    _$isMoreLoadingAtom.reportRead();
    return super.isMoreLoading;
  }

  @override
  set isMoreLoading(bool value) {
    _$isMoreLoadingAtom.reportWrite(value, super.isMoreLoading, () {
      super.isMoreLoading = value;
    });
  }

  final _$getTransactionsAsyncAction =
      AsyncAction('TransactionsStoreBase.getTransactions');

  @override
  Future getTransactions({bool isForce = false}) {
    return _$getTransactionsAsyncAction
        .run(() => super.getTransactions(isForce: isForce));
  }

  @override
  String toString() {
    return '''
transactions: ${transactions},
isMoreLoading: ${isMoreLoading}
    ''';
  }
}
