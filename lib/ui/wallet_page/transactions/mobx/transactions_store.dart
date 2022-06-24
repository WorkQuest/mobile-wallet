import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/http/api.dart';
import 'package:workquest_wallet_app/model/transactions_response.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';

import '../../../../constants.dart';

part 'transactions_store.g.dart';

class TransactionsStore = TransactionsStoreBase with _$TransactionsStore;

abstract class TransactionsStoreBase extends IStore<bool> with Store {
  @observable
  ObservableList<Tx> transactions = ObservableList<Tx>.of([]);

  @observable
  bool isMoreLoading = false;

  @observable
  bool canMoreLoading = true;

  @observable
  TokenSymbols type = TokenSymbols.WQT;

  @action
  setType(TokenSymbols value) => type = value;

  String get myAddress => AccountRepository().userWallet!.address!;


  @action
  getTransactions() async {
    final _type = _getTypeNetwork();
    if (_type != ConfigNameNetwork.testnet && _type != ConfigNameNetwork.devnet ) {
      transactions.clear();
      onSuccess(true);
      return;
    }
    canMoreLoading = true;
    onLoading();

    try {
      if (transactions.isNotEmpty) {
        transactions.clear();
      }
      isMoreLoading = false;
      List<Tx>? result;
      final _addressToken = Web3Utils.getAddressToken(type);

      if (type == TokenSymbols.WQT) {
        result = await Api().getTransactions(
          AccountRepository().userAddress,
          limit: 10,
          offset: transactions.length,
        );
      } else {
        result = await Api().getTransactionsByToken(
          address: AccountRepository().userAddress,
          addressToken: _addressToken,
          limit: 10,
          offset: transactions.length,
        );
      }

      _setTypeCoinInTxs(result!);

      transactions.addAll(result);

      onSuccess(true);
    } on FormatException catch (e, trace) {
      print('$e\n$trace');
      onError(e.message);
    } catch (e) {
      print('$e');
      onError(e.toString());
    }
  }

  @action
  getTransactionsMore() async {
    final _type = _getTypeNetwork();
    if (_type != ConfigNameNetwork.testnet && _type != ConfigNameNetwork.devnet ) {
      transactions.clear();
      onSuccess(true);
      return;
    }
    isMoreLoading = true;
    try {
      List<Tx>? result;
      final _addressToken = Web3Utils.getAddressToken(type);
      if (type == TokenSymbols.WQT) {
        result = await Api().getTransactions(
          AccountRepository().userAddress,
          limit: 10,
          offset: transactions.length,
        );
      } else {
        result = await Api().getTransactionsByToken(
          address: AccountRepository().userAddress,
          addressToken: _addressToken,
          limit: 10,
          offset: transactions.length,
        );
      }
      if (result!.isEmpty) {
        canMoreLoading = false;
      }
      result.map((tran) {
        final index = transactions.indexWhere((element) => element.hash == tran.hash);
        if (index == -1) {
          transactions.add(tran);
        }
      }).toList();
      await Future.delayed(const Duration(milliseconds: 500));
      isMoreLoading = false;
      onSuccess(true);
    } catch (e, trace) {
      print('$e\n$trace');
      onError(e.toString());
    }
  }

  _setTypeCoinInTxs(List<Tx> txs) {
    txs.map((tran) {
      if (tran.fromAddressHash!.hex == Web3Utils.getAddressToken(TokenSymbols.WUSD)) {
        tran.coin = TokenSymbols.WUSD;
      } else if (tran.fromAddressHash!.hex == Web3Utils.getAddressToken(TokenSymbols.wETH)) {
        tran.coin = TokenSymbols.wETH;
      } else if (tran.fromAddressHash!.hex == Web3Utils.getAddressToken(TokenSymbols.wBNB)) {
        tran.coin = TokenSymbols.wBNB;
      } else if (tran.fromAddressHash!.hex == Web3Utils.getAddressToken(TokenSymbols.USDT)) {
        tran.coin = TokenSymbols.USDT;
      } else {
        tran.coin = TokenSymbols.WQT;
      }
    }).toList();
  }

  ConfigNameNetwork _getTypeNetwork() => AccountRepository().configName!;

}
