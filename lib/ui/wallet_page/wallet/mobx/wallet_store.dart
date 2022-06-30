import 'dart:math';

import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';

part 'wallet_store.g.dart';

class WalletStore = WalletStoreBase with _$WalletStore;

abstract class WalletStoreBase extends IStore<bool> with Store {
  @observable
  ObservableList<_CoinEntity> coins = ObservableList.of([]);

  @observable
  int index = 0;

  @observable
  TokenSymbols type = TokenSymbols.WQT;

  @action
  setType(TokenSymbols value) => type = value;

  @action
  setIndex(int value) {
    index = value;
    print('index - $index');
  }

  @action
  clearData() {
    coins.clear();
    index = 0;
    type = TokenSymbols.WQT;
  }

  @action
  getCoins({bool isForce = true}) async {
    if (isForce) {
      onLoading();
    }
    try {
      final _tokens =
          Configs.configsNetwork[AccountRepository().networkName.value]!.dataCoins;
      final _listCoinsEntity = await _getCoinEntities(_tokens);
      if (isForce) {
        coins.clear();
      }
      _setCoins(_listCoinsEntity);
      if (isForce) {
        onSuccess(true);
      }

      onSuccess(true);
    } catch (e) {
      onError(e.toString());
    }
  }

  _setCoins(List<_CoinEntity> listCoins) {
    if (coins.isNotEmpty) {
      coins.map((element) {
        element.amount = listCoins
            .firstWhere((element) => element.symbol == element.symbol)
            .amount;
      }).toList();
    } else {
      coins.addAll(listCoins);
    }
  }

  Future<List<_CoinEntity>> _getCoinEntities(List<DataCoins> coins) async {
    List<_CoinEntity> _result = [];
    final _client = AccountRepository().getClient();
    await Stream.fromIterable(coins).asyncMap((coin) async {
      if (coin.addressToken == null) {
        final _balance =
            await _client.getBalance(AccountRepository().privateKey);
        final _amount =
            (_balance.getInWei.toDouble() * pow(10, -18)).toStringAsFixed(8);
        _result.add(_CoinEntity(coin.symbolToken, _amount));
      } else {
        final _amount = await _client.getBalanceFromContract(coin.addressToken!,
            isUSDT: coin.symbolToken == TokenSymbols.USDT);
        _result.add(_CoinEntity(coin.symbolToken, _amount.toString()));
      }
    }).toList();

    return _result;
  }
}

class _CoinEntity {
  final TokenSymbols symbol;
  String? amount;

  _CoinEntity(this.symbol, [this.amount]);
}
