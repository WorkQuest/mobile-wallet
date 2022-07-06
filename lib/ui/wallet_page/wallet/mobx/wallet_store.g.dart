// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WalletStore on WalletStoreBase, Store {
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
  Future getCoins({bool isForce = true}) {
    return _$getCoinsAsyncAction.run(() => super.getCoins(isForce: isForce));
  }

  late final _$WalletStoreBaseActionController =
      ActionController(name: 'WalletStoreBase', context: context);

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
coins: ${coins},
    ''';
  }
}
