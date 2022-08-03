// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TransferStore on TransferStoreBase, Store {
  Computed<bool>? _$statusButtonTransferComputed;

  @override
  bool get statusButtonTransfer => (_$statusButtonTransferComputed ??=
          Computed<bool>(() => super.statusButtonTransfer,
              name: 'TransferStoreBase.statusButtonTransfer'))
      .value;

  late final _$maxAmountAtom =
      Atom(name: 'TransferStoreBase.maxAmount', context: context);

  @override
  double? get maxAmount {
    _$maxAmountAtom.reportRead();
    return super.maxAmount;
  }

  @override
  set maxAmount(double? value) {
    _$maxAmountAtom.reportWrite(value, super.maxAmount, () {
      super.maxAmount = value;
    });
  }

  late final _$addressToAtom =
      Atom(name: 'TransferStoreBase.addressTo', context: context);

  @override
  String get addressTo {
    _$addressToAtom.reportRead();
    return super.addressTo;
  }

  @override
  set addressTo(String value) {
    _$addressToAtom.reportWrite(value, super.addressTo, () {
      super.addressTo = value;
    });
  }

  late final _$amountAtom =
      Atom(name: 'TransferStoreBase.amount', context: context);

  @override
  String get amount {
    _$amountAtom.reportRead();
    return super.amount;
  }

  @override
  set amount(String value) {
    _$amountAtom.reportWrite(value, super.amount, () {
      super.amount = value;
    });
  }

  late final _$feeAtom = Atom(name: 'TransferStoreBase.fee', context: context);

  @override
  String get fee {
    _$feeAtom.reportRead();
    return super.fee;
  }

  @override
  set fee(String value) {
    _$feeAtom.reportWrite(value, super.fee, () {
      super.fee = value;
    });
  }

  late final _$currentCoinAtom =
      Atom(name: 'TransferStoreBase.currentCoin', context: context);

  @override
  CoinItem? get currentCoin {
    _$currentCoinAtom.reportRead();
    return super.currentCoin;
  }

  @override
  set currentCoin(CoinItem? value) {
    _$currentCoinAtom.reportWrite(value, super.currentCoin, () {
      super.currentCoin = value;
    });
  }

  late final _$setCoinAsyncAction =
      AsyncAction('TransferStoreBase.setCoin', context: context);

  @override
  Future setCoin(CoinItem? value) {
    return _$setCoinAsyncAction.run(() => super.setCoin(value));
  }

  late final _$getMaxAmountAsyncAction =
      AsyncAction('TransferStoreBase.getMaxAmount', context: context);

  @override
  Future getMaxAmount() {
    return _$getMaxAmountAsyncAction.run(() => super.getMaxAmount());
  }

  late final _$getFeeAsyncAction =
      AsyncAction('TransferStoreBase.getFee', context: context);

  @override
  Future getFee() {
    return _$getFeeAsyncAction.run(() => super.getFee());
  }

  late final _$checkBeforeSendAsyncAction =
      AsyncAction('TransferStoreBase.checkBeforeSend', context: context);

  @override
  Future checkBeforeSend({bool isTimerUpdate = false}) {
    return _$checkBeforeSendAsyncAction
        .run(() => super.checkBeforeSend(isTimerUpdate: isTimerUpdate));
  }

  late final _$TransferStoreBaseActionController =
      ActionController(name: 'TransferStoreBase', context: context);

  @override
  dynamic setFee(String value) {
    final _$actionInfo = _$TransferStoreBaseActionController.startAction(
        name: 'TransferStoreBase.setFee');
    try {
      return super.setFee(value);
    } finally {
      _$TransferStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAddressTo(String value) {
    final _$actionInfo = _$TransferStoreBaseActionController.startAction(
        name: 'TransferStoreBase.setAddressTo');
    try {
      return super.setAddressTo(value);
    } finally {
      _$TransferStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAmount(String value) {
    final _$actionInfo = _$TransferStoreBaseActionController.startAction(
        name: 'TransferStoreBase.setAmount');
    try {
      return super.setAmount(value);
    } finally {
      _$TransferStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearData() {
    final _$actionInfo = _$TransferStoreBaseActionController.startAction(
        name: 'TransferStoreBase.clearData');
    try {
      return super.clearData();
    } finally {
      _$TransferStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
maxAmount: ${maxAmount},
addressTo: ${addressTo},
amount: ${amount},
fee: ${fee},
currentCoin: ${currentCoin},
statusButtonTransfer: ${statusButtonTransfer}
    ''';
  }
}
