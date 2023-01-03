// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TransactionsStore on TransactionsStoreBase, Store {
  late final _$transactionsAtom =
      Atom(name: 'TransactionsStoreBase.transactions', context: context);

  @override
  ObservableList<TxListEntity> get transactions {
    _$transactionsAtom.reportRead();
    return super.transactions;
  }

  @override
  set transactions(ObservableList<TxListEntity> value) {
    _$transactionsAtom.reportWrite(value, super.transactions, () {
      super.transactions = value;
    });
  }

  late final _$isMoreLoadingAtom =
      Atom(name: 'TransactionsStoreBase.isMoreLoading', context: context);

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

  late final _$canMoreLoadingAtom =
      Atom(name: 'TransactionsStoreBase.canMoreLoading', context: context);

  @override
  bool get canMoreLoading {
    _$canMoreLoadingAtom.reportRead();
    return super.canMoreLoading;
  }

  @override
  set canMoreLoading(bool value) {
    _$canMoreLoadingAtom.reportWrite(value, super.canMoreLoading, () {
      super.canMoreLoading = value;
    });
  }

  late final _$typeAtom =
      Atom(name: 'TransactionsStoreBase.type', context: context);

  @override
  TokenSymbols get type {
    _$typeAtom.reportRead();
    return super.type;
  }

  @override
  set type(TokenSymbols value) {
    _$typeAtom.reportWrite(value, super.type, () {
      super.type = value;
    });
  }

  late final _$getTransactionsAsyncAction =
      AsyncAction('TransactionsStoreBase.getTransactions', context: context);

  @override
  Future getTransactions() {
    return _$getTransactionsAsyncAction.run(() => super.getTransactions());
  }

  late final _$getTransactionsMoreAsyncAction = AsyncAction(
      'TransactionsStoreBase.getTransactionsMore',
      context: context);

  @override
  Future getTransactionsMore() {
    return _$getTransactionsMoreAsyncAction
        .run(() => super.getTransactionsMore());
  }

  late final _$TransactionsStoreBaseActionController =
      ActionController(name: 'TransactionsStoreBase', context: context);

  @override
  dynamic setType(TokenSymbols value) {
    final _$actionInfo = _$TransactionsStoreBaseActionController.startAction(
        name: 'TransactionsStoreBase.setType');
    try {
      return super.setType(value);
    } finally {
      _$TransactionsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearData() {
    final _$actionInfo = _$TransactionsStoreBaseActionController.startAction(
        name: 'TransactionsStoreBase.clearData');
    try {
      return super.clearData();
    } finally {
      _$TransactionsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addTransaction(Tx transaction) {
    final _$actionInfo = _$TransactionsStoreBaseActionController.startAction(
        name: 'TransactionsStoreBase.addTransaction');
    try {
      return super.addTransaction(transaction);
    } finally {
      _$TransactionsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
transactions: ${transactions},
isMoreLoading: ${isMoreLoading},
canMoreLoading: ${canMoreLoading},
type: ${type}
    ''';
  }
}
