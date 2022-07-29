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

      final _currentTokenIsNative = _address.isEmpty;
      final _isCurrentToken = _address == transaction.fromAddressHash!.hex ||
          _address == transaction.toAddressHash!.hex ||
          _currentTokenIsNative;
      if (!_isCurrentToken) {
        return;
      }
      final increase = transaction.fromAddressHash!.hex! !=
          (AccountRepository().userWallet?.address ?? '1234');
      transaction.coin = increase
          ? _getTitleCoin(
              transaction.fromAddressHash!.hex!,
              transaction.token_contract_address_hash?.hex,
              fromSocket: true,
            )
          : _getTitleCoin(
              transaction.toAddressHash!.hex!,
              transaction.token_contract_address_hash?.hex,
              fromSocket: true,
            );
      final _index =
          transactions.indexWhere((element) => element.hash == transaction.hash);
      if (_index == -1) {
        transactions.insert(0, transaction);
      }
    } catch (e, trace) {
      print('addTransaction | $e, $trace');
      onError(e.toString());
    }
  }

  _setTypeCoinInTxs(List<Tx> txs) {
    txs.map((tran) {
      final increase = tran.fromAddressHash!.hex! !=
          (AccountRepository().userWallet?.address ?? '1234');
      tran.coin = increase
          ? _getTitleCoin(
              tran.fromAddressHash!.hex!, tran.token_contract_address_hash?.hex)
          : _getTitleCoin(
              tran.toAddressHash!.hex!, tran.token_contract_address_hash?.hex);
    }).toList();
  }

  TokenSymbols _getTitleCoin(
    String addressContract,
    String? contractAddress, {
    bool fromSocket = false,
  }) {
    if (type == TokenSymbols.WQT || fromSocket) {
      final _dataTokens = AccountRepository().getConfigNetworkWorknet().dataCoins;
      final _address = contractAddress ?? addressContract;
      if (_address ==
          _dataTokens
              .firstWhere((element) => element.symbolToken == TokenSymbols.WUSD)
              .addressToken) {
        return TokenSymbols.WUSD;
      } else if (_address ==
          _dataTokens
              .firstWhere((element) => element.symbolToken == TokenSymbols.wBNB)
              .addressToken) {
        return TokenSymbols.wBNB;
      } else if (_address ==
          _dataTokens
              .firstWhere((element) => element.symbolToken == TokenSymbols.wETH)
              .addressToken) {
        return TokenSymbols.wETH;
      } else if (_address ==
          _dataTokens
              .firstWhere((element) => element.symbolToken == TokenSymbols.USDT)
              .addressToken) {
        return TokenSymbols.USDT;
      } else {
        return TokenSymbols.WQT;
      }
    } else {
      if (contractAddress != null) {
        final _dataTokens = AccountRepository().getConfigNetwork().dataCoins;
        if (contractAddress ==
            _dataTokens
                .firstWhere((element) => element.symbolToken == TokenSymbols.WUSD)
                .addressToken) {
          return TokenSymbols.WUSD;
        } else if (contractAddress ==
            _dataTokens
                .firstWhere((element) => element.symbolToken == TokenSymbols.wBNB)
                .addressToken) {
          return TokenSymbols.wBNB;
        } else if (contractAddress ==
            _dataTokens
                .firstWhere((element) => element.symbolToken == TokenSymbols.wETH)
                .addressToken) {
          return TokenSymbols.wETH;
        } else if (contractAddress ==
            _dataTokens
                .firstWhere((element) => element.symbolToken == TokenSymbols.USDT)
                .addressToken) {
          return TokenSymbols.USDT;
        } else {
          return TokenSymbols.WQT;
        }
      }
      return type;
    }
  }

  bool get _isOtherNetwork {
    if (_typeNetwork != NetworkName.workNetTestnet &&
        _typeNetwork != NetworkName.workNetMainnet) {
      return true;
    }
    return false;
  }
}
