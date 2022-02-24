import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';

part 'wallet_store.g.dart';

class WalletStore = WalletStoreBase with _$WalletStore;

abstract class WalletStoreBase extends IStore<bool> with Store {
  @observable
  ObservableList<BalanceItem> coins = ObservableList.of([]);

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
      final wqt = await AccountRepository()
          .client!
          .getBalanceFromContract(AddressCoins.wqt);
      final wEth = await AccountRepository()
          .client!
          .getBalanceFromContract(AddressCoins.wEth);
      final wBnb = await AccountRepository()
          .client!
          .getBalanceFromContract(AddressCoins.wBnb);


      coins.replaceRange(0, coins.length, [
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

      if (isForce) {
        onSuccess(true);
      }
    } catch (e) {
      onError(e.toString());
    }
  }
}
