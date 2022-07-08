import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/json_rpc.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/ui/wallet_page/transactions/mobx/transactions_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/mobx/wallet_store.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';

part 'confirm_transfer_store.g.dart';

class ConfirmTransferStore = ConfirmTransferStoreBase with _$ConfirmTransferStore;

abstract class ConfirmTransferStoreBase extends IStore<bool> with Store {
  @action
  sendTransaction(String addressTo, String amount, TokenSymbols typeCoin, Decimal fee) async {
    onLoading();
    try {
      final _currentListTokens = AccountRepository().getConfigNetwork().dataCoins;
      final _isToken = typeCoin != _currentListTokens.first.symbolToken;
      await Web3Utils.checkPossibilityTx(typeCoin: typeCoin, amount: double.parse(amount), fee: fee);
      await AccountRepository().client!.sendTransaction(
            isToken: _isToken,
            addressTo: addressTo,
            amount: amount,
            coin: typeCoin,
          );
      GetIt.I.get<WalletStore>().getCoins();
      onSuccess(true);
      await Future.delayed(const Duration(seconds: 4));
      GetIt.I.get<TransactionsStore>().getTransactions();
    } on SocketException catch (_) {
      onError("Lost connection to server");
    } on RPCError catch (e) {
      onError(e.message);
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }
}
