import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';

import '../../../transfer_page/confirm_page/mobx/confirm_transfer_store.dart';

part 'wallet_store.g.dart';

class WalletStore = WalletStoreBase with _$WalletStore;

abstract class WalletStoreBase extends IStore<bool> with Store {
  @observable
  ObservableList<BalanceItem> coins = ObservableList.of([]);

  @observable
  int index = 0;

  @observable
  TYPE_COINS type = TYPE_COINS.wqt;

  @action
  setType(TYPE_COINS value) => type = value;

  @action
  setIndex(int value) {
    index = value;
    print('index - $index');
  }

  @action
  getCoins({bool isForce = true}) async {
    if (isForce) {
      onLoading();
    }
    try {
      print('getCoins');

      final list = await AccountRepository().client!.getAllBalance(AccountRepository().privateKey);

      final wqt = list.firstWhere((element) => element.title == 'ether');
      final wUsd = await AccountRepository().client!.getBalanceFromContract(AddressCoins.wUsd);
      final wEth = await AccountRepository().client!.getBalanceFromContract(AddressCoins.wEth);
      final wBnb = await AccountRepository().client!.getBalanceFromContract(AddressCoins.wBnb);
      final uSdt = await AccountRepository().client!.getBalanceFromContract(AddressCoins.uSdt);

      if (coins.isNotEmpty) {
        coins[0].amount = wqt.amount;
        coins[1].amount = wUsd.toString();
        coins[2].amount = wBnb.toString();
        coins[3].amount = wEth.toString();
        coins[4].amount = uSdt.toString();
      } else {
        coins.addAll([
          BalanceItem(
            "WQT",
            wqt.amount,
          ),
          BalanceItem(
            "WUSD",
            wUsd.toString(),
          ),
          BalanceItem(
            "wBNB",
            wBnb.toString(),
          ),
          BalanceItem(
            "wETH",
            wEth.toString(),
          ),
          BalanceItem(
            "USDT",
            uSdt.toString(),
          ),
        ]);
      }

      onSuccess(true);
    } catch (e) {
      onError(e.toString());
    }
  }
}
