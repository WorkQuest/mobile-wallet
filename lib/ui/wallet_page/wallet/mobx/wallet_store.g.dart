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

  final _$indexAtom = Atom(name: 'WalletStoreBase.index');

  @override
  int get index {
    _$indexAtom.reportRead();
    return super.index;
  }

  @override
  set index(int value) {
    _$indexAtom.reportWrite(value, super.index, () {
      super.index = value;
    });
  }

  final _$getCoinsAsyncAction = AsyncAction('WalletStoreBase.getCoins');

  @override
  Future getCoins({bool isForce = true}) {
    return _$getCoinsAsyncAction.run(() => super.getCoins(isForce: isForce));
  }

  final _$WalletStoreBaseActionController =
      ActionController(name: 'WalletStoreBase');

  @override
  dynamic setIndex(int value) {
    final _$actionInfo = _$WalletStoreBaseActionController.startAction(
        name: 'WalletStoreBase.setIndex');
    try {
      return super.setIndex(value);
    } finally {
      _$WalletStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
coins: ${coins},
index: ${index}
    ''';
  }
}
