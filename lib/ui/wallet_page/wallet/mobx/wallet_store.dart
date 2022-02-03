import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
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

      final list = await AccountRepository()
          .client!
          .getAllBalance(AccountRepository().privateKey);
      if (coins.isNotEmpty) {
        coins.clear();
      }
      final ether = list. firstWhere((element) => element.title == 'ether');
      coins.add(BalanceItem(
        "WUSD",
        ether.amount,
      ));
      final wqt = await AccountRepository().client!.getBalanceFromContract('0x917dc1a9E858deB0A5bDCb44C7601F655F728DfE');
      coins.add(BalanceItem(
        "WQT",
        wqt.toString(),
      ));

      if (isForce) {
       onSuccess(true);
      }
    } catch (e) {
      onError(e.toString());
    }
  }
}
