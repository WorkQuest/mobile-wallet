import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/json_rpc.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/ui/wallet_page/transactions/mobx/transactions_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/mobx/wallet_store.dart';

part 'confirm_transfer_store.g.dart';

class ConfirmTransferStore = ConfirmTransferStoreBase
    with _$ConfirmTransferStore;

abstract class ConfirmTransferStoreBase extends IStore<bool> with Store {
  @action
  sendTransaction(String addressTo, String amount, TYPE_COINS typeCoin) async {
    onLoading();
    try {
      await AccountRepository().client!.sendTransaction(
            privateKey: AccountRepository().privateKey,
            addressTo: addressTo,
            amount: amount,
            coin: typeCoin,
          );
      GetIt.I.get<WalletStore>().getCoins();
      GetIt.I.get<TransactionsStore>().getTransactions(isForce: true);
      onSuccess(true);
    } on SocketException catch (_) {
      onError("Lost connection to server");
    } on RPCError catch (e) {
      print('qweasd' + e.runtimeType.toString());
      print('message - ${e.message}');
      print('data - ${e.data}');
      print('errorCode - ${e.errorCode}');
      onError(e.message);
    }
  }

}

enum TYPE_COINS {
  wusd, wqt, wBnb, wEth
}
