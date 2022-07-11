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

  NetworkName get _typeNetwork => AccountRepository().networkName.value!;

  @action
  clearData() {
    transactions.clear();
    isMoreLoading = false;
    canMoreLoading = true;
    type = TokenSymbols.WQT;
  }

  @action
  getTransactions() async {
    if (_isOtherNetwork) {
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
    } on FormatException catch (e) {
      // print('$e\n$trace');
      onError(e.message);
    } catch (e) {
      // print('$e');
      onError(e.toString());
    }
  }

  @action
  getTransactionsMore() async {
    if (_isOtherNetwork) {
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
      transactions.addAll(result);
      isMoreLoading = false;
      onSuccess(true);
    } catch (e) {
      // print('$e\n$trace');
      onError(e.toString());
    }
  }

  @action
  addTransaction(Tx transaction) {
    try {
      if (isLoading) {
        return;
      }
      final _address = Web3Utils.getAddressToken(type);
      print('_address: $_address');
      print('transaction.fromAddressHash!.hex: ${transaction.fromAddressHash!.hex}');
      print('_address != transaction.fromAddressHash!.hex: ${_address != transaction.fromAddressHash!.hex}');
      if (_address != transaction.fromAddressHash!.hex && _address.isNotEmpty) {
        return;
      }
      print('success');
      transactions.insert(0, transaction);
    } catch (e) {
      print('addTransaction | $e');
      onError(e.toString());
    }
  }

  _setTypeCoinInTxs(List<Tx> txs) {
    txs.map((tran) {
      if (tran.fromAddressHash!.hex ==
          Web3Utils.getAddressToken(TokenSymbols.WUSD)) {
        tran.coin = TokenSymbols.WUSD;
      } else if (tran.fromAddressHash!.hex ==
          Web3Utils.getAddressToken(TokenSymbols.wETH)) {
        tran.coin = TokenSymbols.wETH;
      } else if (tran.fromAddressHash!.hex ==
          Web3Utils.getAddressToken(TokenSymbols.wBNB)) {
        tran.coin = TokenSymbols.wBNB;
      } else if (tran.fromAddressHash!.hex ==
          Web3Utils.getAddressToken(TokenSymbols.USDT)) {
        tran.coin = TokenSymbols.USDT;
      } else {
        tran.coin = TokenSymbols.WQT;
      }
    }).toList();
  }

  bool get _isOtherNetwork {
    if (_typeNetwork != NetworkName.workNetTestnet &&
        _typeNetwork != NetworkName.workNetMainnet) {
      return true;
    }
    return false;
  }
}
