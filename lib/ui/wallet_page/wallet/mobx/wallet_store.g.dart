// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WalletStore on WalletStoreBase, Store {
  late final _$currentTokenAtom =
      Atom(name: 'WalletStoreBase.currentToken', context: context);

  @override
  TokenSymbols get currentToken {
    _$currentTokenAtom.reportRead();
    return super.currentToken;
  }

  @override
  set currentToken(TokenSymbols value) {
    _$currentTokenAtom.reportWrite(value, super.currentToken, () {
      super.currentToken = value;
    });
  }

  late final _$coinsAtom =
      Atom(name: 'WalletStoreBase.coins', context: context);

  @override
  ObservableList<_CoinEntity> get coins {
    _$coinsAtom.reportRead();
    return super.coins;
  }

  @override
  set coins(ObservableList<_CoinEntity> value) {
    _$coinsAtom.reportWrite(value, super.coins, () {
      super.coins = value;
    });
  }

  late final _$getCoinsAsyncAction =
      AsyncAction('WalletStoreBase.getCoins', context: context);

  @override
  Future getCoins(
      {bool isForce = true, bool tryAgain = true, bool fromSwap = false}) {
    return _$getCoinsAsyncAction.run(() => super
        .getCoins(isForce: isForce, tryAgain: tryAgain, fromSwap: fromSwap));
  }

  late final _$WalletStoreBaseActionController =
      ActionController(name: 'WalletStoreBase', context: context);

  @override
  dynamic setCurrentToken(TokenSymbols value) {
    final _$actionInfo = _$WalletStoreBaseActionController.startAction(
        name: 'WalletStoreBase.setCurrentToken');
    try {
      return super.setCurrentToken(value);
    } finally {
      _$WalletStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearData() {
    final _$actionInfo = _$WalletStoreBaseActionController.startAction(
        name: 'WalletStoreBase.clearData');
    try {
      return super.clearData();
    } finally {
      _$WalletStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentToken: ${currentToken},
coins: ${coins}
    ''';
  }
}
