import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/model/transactions_response.dart';
import 'package:workquest_wallet_app/repository/session_repository.dart';
import 'package:workquest_wallet_app/repository/transactions_repository.dart';
import 'package:workquest_wallet_app/ui/wallet_page/transactions/entity/tx_list_entity.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';

part 'transactions_store.g.dart';

class TransactionsStore = TransactionsStoreBase with _$TransactionsStore;

abstract class TransactionsStoreBase extends IStore<bool> with Store {
  final ITransactionsRepository _repository;

  TransactionsStoreBase() : _repository = TransactionsRepository();

  @observable
  ObservableList<TxListEntity> transactions = ObservableList<TxListEntity>.of([]);

  @observable
  bool isMoreLoading = false;

  @observable
  bool canMoreLoading = true;

  @observable
  TokenSymbols type = TokenSymbols.WQT;

  @action
  setType(TokenSymbols value) => type = value;

  NetworkName get _typeNetwork => GetIt.I.get<SessionRepository>().networkName.value!;

  @action
  clearData() {
    transactions.clear();
    isMoreLoading = false;
    canMoreLoading = true;
    type = TokenSymbols.WQT;
  }

  @action
  getTransactions() async {
    canMoreLoading = true;
    onLoading();

    try {
      if (transactions.isNotEmpty) {
        transactions.clear();
      }
      isMoreLoading = false;

      if (_isOtherNetwork) {
        final result = await _repository.getTransactionsOtherNetwork(
          page: (transactions.length / 10).floorToDouble().toInt() + 1,
        );
        transactions.addAll(result);
      } else {
        final _nativeToken = type == TokenSymbols.WQT;
        if (_nativeToken) {
          final result = await _repository.getNativeTransactionsWorkNet(
            userAddress: GetIt.I.get<SessionRepository>().userAddress,
            offset: transactions.length,
          );
          transactions.addAll(result);
        } else {
          final result = await _repository.getTokenTransactionsWorkNet(
            userAddress: GetIt.I.get<SessionRepository>().userAddress,
            tokenAddress: Web3Utils.getAddressToken(type),
            offset: transactions.length,
          );
          transactions.addAll(result);
        }
      }
      onSuccess(true);
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  getTransactionsMore() async {
    isMoreLoading = true;
    try {
      if (_isOtherNetwork) {
        final result = await _repository.getTransactionsOtherNetwork(
          page: (transactions.length / 10).floorToDouble().toInt() + 1,
        );
        if (result.isEmpty) {
          canMoreLoading = false;
        }
        transactions.addAll(result);
      } else {
        final _nativeToken = type == TokenSymbols.WQT;
        if (_nativeToken) {
          final result = await _repository.getNativeTransactionsWorkNet(
            userAddress: GetIt.I.get<SessionRepository>().userAddress,
            offset: transactions.length,
          );
          if (result.isEmpty) {
            canMoreLoading = false;
          }
          transactions.addAll(result);
        } else {
          final result = await _repository.getTokenTransactionsWorkNet(
            userAddress: GetIt.I.get<SessionRepository>().userAddress,
            tokenAddress: Web3Utils.getAddressToken(type),
            offset: transactions.length,
          );
          if (result.isEmpty) {
            canMoreLoading = false;
          }
          transactions.addAll(result);
        }
      }
      isMoreLoading = false;
      onSuccess(true);
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  addTransaction(Tx transaction) {
    try {
      if (isLoading || _isOtherNetwork) {
        return;
      }
      final _address = Web3Utils.getAddressToken(type);

      final _currentTokenIsNative = _address.isEmpty;
      final _isCurrentToken = _address == transaction.fromAddressHash?.hex ||
          _address == transaction.toAddressHash?.hex ||
          _address == transaction.token_contract_address_hash?.hex ||
          _currentTokenIsNative;
      if (!_isCurrentToken) {
        return;
      }
      final _index = transactions.indexWhere((element) => element.hashTx == transaction.hash);
      if (_index == -1) {
        transactions.insert(0, TxListEntity.fromWorkNet(transaction));
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  bool get _isOtherNetwork {
    if (_typeNetwork != NetworkName.workNetTestnet && _typeNetwork != NetworkName.workNetMainnet) {
      return true;
    }
    return false;
  }
}
