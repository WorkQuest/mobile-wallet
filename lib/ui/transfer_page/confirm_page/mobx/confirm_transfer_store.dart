import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/ui/wallet_page/transactions/mobx/transactions_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/mobx/wallet_store.dart';

part 'confirm_transfer_store.g.dart';

class ConfirmTransferStore = ConfirmTransferStoreBase
    with _$ConfirmTransferStore;

abstract class ConfirmTransferStoreBase extends IStore<bool> with Store {
  @action
  sendTransaction(String addressTo, String amount, String titleCoin) async {
    onLoading();
    try {
      await AccountRepository().client!.sendTransaction(
            privateKey: AccountRepository().privateKey,
            address: addressTo,
            amount: amount,
            coin: getType(titleCoin),
          );
      GetIt.I.get<WalletStore>().getCoins();
      GetIt.I.get<TransactionsStore>().getTransactions(isForce: true);
      onSuccess(true);
    } on SocketException catch (_) {
      onError("Lost connection to server");
    } catch (e) {
      onError(e.toString());
    }
  }

  TYPE_COINS getType(String title) {
    switch (title) {
      case "WUSD":
        return TYPE_COINS.wusd;
      case "WQT":
        return TYPE_COINS.wqt;
      default:
        return TYPE_COINS.wqt;
    }
  }
}

enum TYPE_COINS {
  wusd, wqt
}