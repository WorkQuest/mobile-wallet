import 'dart:io';
import 'dart:math';

import 'package:mobx/mobx.dart';
import 'package:web3dart/web3dart.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';

part 'transfer_store.g.dart';

class TransferStore = TransferStoreBase with _$TransferStore;

abstract class TransferStoreBase extends IStore<bool> with Store {
  @observable
  String titleSelectedCoin = '';

  @observable
  String addressTo = '';

  @observable
  String amount = '';

  @observable
  String fee = '';

  @computed
  bool get statusButtonTransfer =>
      titleSelectedCoin.isNotEmpty && addressTo.isNotEmpty && amount.isNotEmpty;

  @action
  setAddressTo(String value) => addressTo = value;

  @action
  setAmount(String value) => amount = value;

  @action
  setTitleSelectedCoin(String value) => titleSelectedCoin = value;

  @action
  getMaxAmount() async {
    onLoading();
    try {
      if (titleSelectedCoin.isEmpty) {
        throw const FormatException('Choose a coin');
      }
      final balance = await AccountRepository()
          .client!
          .getBalance(AccountRepository().privateKey);
      final gas = await AccountRepository().client!.getGas();
      switch (titleSelectedCoin) {
        case "WUSD":
          final count = balance.getValueInUnitBI(EtherUnit.ether);
          amount = (count - gas.getInEther).toString();
          break;
        case "WQT":
          final count = balance.getValueInUnitBI(EtherUnit.ether).toDouble() * 0.3;
          amount = (count - gas.getInEther.toDouble() * 0.3).toString();
          break;
        default:
          break;
      }
      onSuccess(true);
    } on SocketException catch (e) {
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
    } on SocketException catch (e) {
      onError("Lost connection to server");
    }
  }
}
