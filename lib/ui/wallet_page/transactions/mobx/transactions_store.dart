import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/http/api.dart';
import 'package:workquest_wallet_app/model/transactions_response.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/ui/transfer_page/confirm_page/mobx/confirm_transfer_store.dart';
import 'package:workquest_wallet_app/utils/coins.dart';

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
  TYPE_COINS type = TYPE_COINS.wqt;

  @action
  setType(TYPE_COINS value) => type = value;

  String get myAddress => AccountRepository().userWallet!.address!;

  AddressCoins get addresses => AccountRepository().getConfigNetwork().addresses;

  @action
  getTransactions() async {
    canMoreLoading = true;
    onLoading();

    try {
      if (transactions.isNotEmpty) {
        transactions.clear();
      }
      isMoreLoading = false;
      List<Tx>? result;
      switch (type) {
        case TYPE_COINS.wqt:
          result = await Api().getTransactions(
            myAddress,
            limit: 10,
            offset: transactions.length,
          );
          break;
        case TYPE_COINS.wusd:
          result = await Api().getTransactionsByToken(
            address: myAddress,
            addressToken: addresses.wusd,
            limit: 10,
            offset: transactions.length,
          );
          break;
        case TYPE_COINS.wBnb:
          result = await Api().getTransactionsByToken(
            address: myAddress,
            addressToken: addresses.wbnb,
            limit: 10,
            offset: transactions.length,
          );
          break;
        case TYPE_COINS.wEth:
          result = await Api().getTransactionsByToken(
            address: myAddress,
            addressToken: addresses.weth,
            limit: 10,
            offset: transactions.length,
          );
          break;
        case TYPE_COINS.usdt:
          result = await Api().getTransactionsByToken(
            address: myAddress,
            addressToken: addresses.usdt,
            limit: 10,
            offset: transactions.length,
          );
          break;
      }

      result!.map((tran) {
        String address = '';
        if (tran.toAddressHash!.hex! == myAddress) {
          address = tran.fromAddressHash!.hex!;
        } else {
          address = tran.toAddressHash!.hex!;
        }
        tran.coin = CoinsUtils.getTypeCoin(address, addresses);
      }).toList();
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
    isMoreLoading = true;
    try {
      List<Tx>? result;
      switch (type) {
        case TYPE_COINS.wqt:
          result = await Api().getTransactions(
            myAddress,
            limit: 10,
            offset: transactions.length,
          );
          break;
        case TYPE_COINS.wusd:
          result = await Api().getTransactionsByToken(
            address: myAddress,
            addressToken: addresses.wusd,
            limit: 10,
            offset: transactions.length,
          );
          break;
        case TYPE_COINS.wBnb:
          result = await Api().getTransactionsByToken(
            address: myAddress,
            addressToken: addresses.wbnb,
            limit: 10,
            offset: transactions.length,
          );
          break;
        case TYPE_COINS.wEth:
          result = await Api().getTransactionsByToken(
            address: myAddress,
            addressToken: addresses.weth,
            limit: 10,
            offset: transactions.length,
          );
          break;
        case TYPE_COINS.usdt:
          result = await Api().getTransactionsByToken(
            address: myAddress,
            addressToken: addresses.usdt,
            limit: 10,
            offset: transactions.length,
          );
          break;
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

  @action
  addTransaction({required Tx tran}) {
    String address = '';
    if (tran.toAddressHash!.hex! == myAddress) {
      address = tran.fromAddressHash!.hex!;
    } else {
      address = tran.toAddressHash!.hex!;
    }
    tran.coin = CoinsUtils.getTypeCoin(address, addresses);
    if (type == tran.coin || type == TYPE_COINS.wqt) {
      transactions.add(tran);
    }
  }

}
