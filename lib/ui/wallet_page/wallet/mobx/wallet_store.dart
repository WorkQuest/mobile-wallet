import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';

part 'wallet_store.g.dart';

class WalletStore = WalletStoreBase with _$WalletStore;

abstract class WalletStoreBase extends IStore<bool> with Store {
  @observable
  ObservableList<BalanceItem> coins = ObservableList.of([]);

  @observable
  int index = 0;

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

      final list =
          await AccountRepository().client!.getAllBalance(AccountRepository().privateKey);

      final ether = list.firstWhere((element) => element.title == 'ether');
      final wqt =
          await AccountRepository().client!.getBalanceFromContract(AddressCoins.wqt);
      final wEth =
          await AccountRepository().client!.getBalanceFromContract(AddressCoins.wEth);
      final wBnb =
          await AccountRepository().client!.getBalanceFromContract(AddressCoins.wBnb);

      if (coins.isNotEmpty) {
        coins[0].amount = ether.amount;
        coins[1].amount = wqt.toString();
        coins[2].amount = wBnb.toString();
        coins[3].amount = wEth.toString();
      } else {
        coins.addAll([
          BalanceItem(
            "WUSD",
            ether.amount,
          ),
          BalanceItem(
            "WQT",
            wqt.toString(),
          ),
          BalanceItem(
            "wBNB",
            wBnb.toString(),
          ),
          BalanceItem(
            "wETH",
            wEth.toString(),
          ),
        ]);
      }

      onSuccess(true);
    } catch (e) {
      onError(e.toString());
    }
  }
}
