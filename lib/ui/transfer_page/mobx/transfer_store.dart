import 'dart:io';
import 'dart:math';

import 'package:mobx/mobx.dart';
import 'package:web3dart/web3dart.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/ui/transfer_page/confirm_page/mobx/confirm_transfer_store.dart';

part 'transfer_store.g.dart';

class TransferStore = TransferStoreBase with _$TransferStore;

abstract class TransferStoreBase extends IStore<bool> with Store {
  @observable
  TYPE_COINS? typeCoin;

  @observable
  String addressTo = '';

  @observable
  String amount = '';

  @observable
  String fee = '';

  @computed
  bool get statusButtonTransfer =>
      typeCoin != null && addressTo.isNotEmpty && amount.isNotEmpty;

  @action
  setAddressTo(String value) => addressTo = value;

  @action
  setAmount(String value) => amount = value;

  @action
  setTitleSelectedCoin(TYPE_COINS? value) => typeCoin = value;

  @action
  getMaxAmount() async {
    onLoading();
    try {
      final balance = await AccountRepository()
          .client!
          .getBalance(AccountRepository().privateKey);
      final gas = await AccountRepository().client!.getGas();
      switch (typeCoin) {
        case TYPE_COINS.wusd:
          final count = balance.getValueInUnitBI(EtherUnit.ether);
          amount = (count - gas.getInEther).toString();
          break;
        case TYPE_COINS.wqt:
          final count = await AccountRepository().client!.getBalanceFromContract(AddressCoins.wqt);
          amount = (count - gas.getInEther.toDouble() * 0.3).toString();
          break;
        case TYPE_COINS.wEth:
          final count = await AccountRepository().client!.getBalanceFromContract(AddressCoins.wEth);
          amount = (count - gas.getInEther.toDouble() * 0.3).toString();
          break;
        case TYPE_COINS.wBnb:
          final count = await AccountRepository().client!.getBalanceFromContract(AddressCoins.wBnb);
          amount = (count - gas.getInEther.toDouble() * 0.3).toString();
          break;
        default:
          break;
      }
      onSuccess(true);
    } on SocketException catch (_) {
      onError("Lost connection to server");
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }

  }

  @action
  getFee() async {
    try {
      final gas = await AccountRepository().client!.getGas();
      fee = (gas.getInWei.toInt() / pow(10, 18)).toStringAsFixed(17);
    } on SocketException catch (_) {
      onError("Lost connection to server");
    }
  }
}
