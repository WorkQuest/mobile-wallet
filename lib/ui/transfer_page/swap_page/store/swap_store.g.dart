// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swap_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SwapStore on SwapStoreBase, Store {
  late final _$networkAtom =
      Atom(name: 'SwapStoreBase.network', context: context);

  @override
  SwapNetworks? get network {
    _$networkAtom.reportRead();
    return super.network;
  }

  @override
  set network(SwapNetworks? value) {
    _$networkAtom.reportWrite(value, super.network, () {
      super.network = value;
    });
  }

  late final _$tokenAtom = Atom(name: 'SwapStoreBase.token', context: context);

  @override
  SwapToken get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(SwapToken value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  late final _$amountAtom =
      Atom(name: 'SwapStoreBase.amount', context: context);

  @override
  double get amount {
    _$amountAtom.reportRead();
    return super.amount;
  }

  @override
  set amount(double value) {
    _$amountAtom.reportWrite(value, super.amount, () {
      super.amount = value;
    });
  }

  late final _$maxAmountAtom =
      Atom(name: 'SwapStoreBase.maxAmount', context: context);

  @override
  double get maxAmount {
    _$maxAmountAtom.reportRead();
    return super.maxAmount;
  }

  @override
  set maxAmount(double value) {
    _$maxAmountAtom.reportWrite(value, super.maxAmount, () {
      super.maxAmount = value;
    });
  }

  late final _$isConnectAtom =
      Atom(name: 'SwapStoreBase.isConnect', context: context);

  @override
  bool get isConnect {
    _$isConnectAtom.reportRead();
    return super.isConnect;
  }

  @override
  set isConnect(bool value) {
    _$isConnectAtom.reportWrite(value, super.isConnect, () {
      super.isConnect = value;
    });
  }

  late final _$setNetworkAsyncAction =
      AsyncAction('SwapStoreBase.setNetwork', context: context);

  @override
  Future setNetwork(SwapNetworks value) {
    return _$setNetworkAsyncAction.run(() => super.setNetwork(value));
  }

  late final _$getMaxBalanceAsyncAction =
      AsyncAction('SwapStoreBase.getMaxBalance', context: context);

  @override
  Future getMaxBalance() {
    return _$getMaxBalanceAsyncAction.run(() => super.getMaxBalance());
  }

  late final _$SwapStoreBaseActionController =
      ActionController(name: 'SwapStoreBase', context: context);

  @override
  dynamic setToken(SwapToken value) {
    final _$actionInfo = _$SwapStoreBaseActionController.startAction(
        name: 'SwapStoreBase.setToken');
    try {
      return super.setToken(value);
    } finally {
      _$SwapStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAmount(double value) {
    final _$actionInfo = _$SwapStoreBaseActionController.startAction(
        name: 'SwapStoreBase.setAmount');
    try {
      return super.setAmount(value);
    } finally {
      _$SwapStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
network: ${network},
token: ${token},
amount: ${amount},
maxAmount: ${maxAmount},
isConnect: ${isConnect}
    ''';
  }
}
