// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WalletStore on WalletStoreBase, Store {
  final _$coinsAtom = Atom(name: 'WalletStoreBase.coins');

  @override
  ObservableList<BalanceItem> get coins {
    _$coinsAtom.reportRead();
    return super.coins;
  }

  @override
  set coins(ObservableList<BalanceItem> value) {
    _$coinsAtom.reportWrite(value, super.coins, () {
      super.coins = value;
    });
  }

  final _$getCoinsAsyncAction = AsyncAction('WalletStoreBase.getCoins');

  @override
  Future getCoins({bool isForce = true}) {
    return _$getCoinsAsyncAction.run(() => super.getCoins(isForce: isForce));
  }

  @override
  String toString() {
    return '''
coins: ${coins}
    ''';
  }
}
