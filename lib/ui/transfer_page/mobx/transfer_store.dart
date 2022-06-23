import 'dart:io';
import 'dart:math';

import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';

part 'transfer_store.g.dart';

class TransferStore = TransferStoreBase with _$TransferStore;

abstract class TransferStoreBase extends IStore<bool> with Store {
  @observable
  TokenSymbols? typeCoin;

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
  setTitleSelectedCoin(TokenSymbols? value) => typeCoin = value;

  @action
  getMaxAmount() async {
    onLoading();
    try {
      final _client = AccountRepository().getClient();
      final _dataCoins = AccountRepository().getConfigNetwork().dataCoins;
      final _isHaveAddressCoin =
          _dataCoins.firstWhere((element) => element.symbolToken == typeCoin).addressToken == null;
      if (_isHaveAddressCoin) {
        final _balance = await _client.getBalance(AccountRepository().privateKey);
        final _balanceInWei = _balance.getInWei;
        final _gasInWei = await _client.getGas();
        amount = ((_balanceInWei - _gasInWei.getInWei).toDouble() * pow(10, -18)).toStringAsFixed(18);
      } else {
        final _balance = await _getBalanceToken(Web3Utils.getAddressToken(typeCoin!));
        amount = _balance.toStringAsFixed(18);
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

  Future<double> _getBalanceToken(String addressToken) async {
    final _balance = await AccountRepository().getClient().getBalanceFromContract(
      addressToken,
      isUSDT: typeCoin == TokenSymbols.USDT,
    );
    return _balance;
  }
}
