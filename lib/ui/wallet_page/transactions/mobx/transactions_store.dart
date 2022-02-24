
import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/http/api.dart';
import 'package:workquest_wallet_app/model/transactions_response.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/ui/transfer_page/confirm_page/mobx/confirm_transfer_store.dart';

import '../../../../constants.dart';

part 'transactions_store.g.dart';

class TransactionsStore = TransactionsStoreBase with _$TransactionsStore;

abstract class TransactionsStoreBase extends IStore<bool> with Store {
  @observable
  ObservableList<Tx> transactions = ObservableList<Tx>.of([]);

  @observable
  bool isMoreLoading = false;

  @observable
  TYPE_COINS type = TYPE_COINS.wusd;

  @action
  setType(TYPE_COINS value) => type = value;

  @action
  getTransactions({bool isForce = false}) async {
    if (isForce) {
      onLoading();
    }

    try {
      if (isForce) {
        if (transactions.isNotEmpty) {
          transactions.clear();
        }
        isMoreLoading = false;
      }
      List<Tx>? result;
      switch (type) {
        case TYPE_COINS.wusd:
          result = await Api().getTransactions(
            AccountRepository().userAddress!,
            limit: 10,
            offset: isForce ? transactions.length : 0,
          );
          break;
        case TYPE_COINS.wqt:
          result = await Api().getTransactionsByToken(
            address: AccountRepository().userAddress!,
            addressToken: AddressCoins.wqt,
            limit: 10,
            offset: isForce ? transactions.length : 0,
          );
          break;
        case TYPE_COINS.wBnb:
          result = await Api().getTransactionsByToken(
            address: AccountRepository().userAddress!,
            addressToken: AddressCoins.wBnb,
            limit: 10,
            offset: isForce ? transactions.length : 0,
          );
          break;
        case TYPE_COINS.wEth:
          result = await Api().getTransactionsByToken(
            address: AccountRepository().userAddress!,
            addressToken: AddressCoins.wEth,
            limit: 10,
            offset: isForce ? transactions.length : 0,
          );
          break;
      }

      result!.map((tran) {
        if (tran.toAddressHash!.hex! == AccountRepository().userAddress) {
          switch (tran.fromAddressHash!.hex!) {
            case AddressCoins.wqt:
              tran.coin = TYPE_COINS.wqt;
              break;
            case AddressCoins.wEth:
              tran.coin = TYPE_COINS.wEth;
              break;
            case AddressCoins.wBnb:
              tran.coin = TYPE_COINS.wBnb;
              break;
            default:
              tran.coin = TYPE_COINS.wusd;
              break;
          }
        } else {
          switch (tran.toAddressHash!.hex!) {
            case AddressCoins.wqt:
              tran.coin = TYPE_COINS.wqt;
              break;
            case AddressCoins.wEth:
              tran.coin = TYPE_COINS.wEth;
              break;
            case AddressCoins.wBnb:
              tran.coin = TYPE_COINS.wBnb;
              break;
            default:
              tran.coin = TYPE_COINS.wusd;
              break;
          }
        }
      }).toList();

      if (isForce) {
        transactions.addAll(result);
      } else {
        result = result.reversed.toList();
        result.map((tran) {
          if (!transactions.contains(tran)) {
            transactions.insert(0, tran);
          }
        }).toList();
      }
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
    isMoreLoading = true;
    try {
      List<Tx>? result;
      switch (type) {
        case TYPE_COINS.wusd:
          result = await Api().getTransactions(
            AccountRepository().userAddress!,
            limit: 10,
            offset: transactions.length,
          );
          break;
        case TYPE_COINS.wqt:
          result = await Api().getTransactionsByToken(
            address: AccountRepository().userAddress!,
            addressToken: AddressCoins.wqt,
            limit: 10,
            offset: transactions.length,
          );
          break;
        case TYPE_COINS.wBnb:
          result = await Api().getTransactionsByToken(
            address: AccountRepository().userAddress!,
            addressToken: AddressCoins.wBnb,
            limit: 10,
            offset: transactions.length,
          );
          break;
        case TYPE_COINS.wEth:
          result = await Api().getTransactionsByToken(
            address: AccountRepository().userAddress!,
            addressToken: AddressCoins.wEth,
            limit: 10,
            offset: transactions.length,
          );
          break;
      }
      result!.map((tran) {

      }).toList();

      transactions.addAll(result);
      await Future.delayed(const Duration(milliseconds: 500));
      isMoreLoading = false;
      onSuccess(true);
    } catch (e, trace) {
      print('$e\n$trace');
      onError(e.toString());
    }
  }
}
