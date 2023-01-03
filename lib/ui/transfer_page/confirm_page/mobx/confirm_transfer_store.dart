import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/json_rpc.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/session_repository.dart';
import 'package:workquest_wallet_app/service/address_service.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';

part 'confirm_transfer_store.g.dart';

class ConfirmTransferStore = ConfirmTransferStoreBase
    with _$ConfirmTransferStore;

abstract class ConfirmTransferStoreBase extends IStore<bool> with Store {
  @action
  sendTransaction(String addressTo, String amount, TokenSymbols typeCoin,
      Decimal fee) async {
    onLoading();
    try {
      final _isBech = addressTo.substring(0, 2).toLowerCase() == 'wq';
      final _currentListTokens =
          GetIt.I.get<SessionRepository>().getConfigNetwork().dataCoins;
      final _isToken = typeCoin != _currentListTokens.first.symbolToken;
      final _credentials =
          await GetIt.I.get<SessionRepository>().client!.getCredentials();
      await Web3Utils.checkPossibilityTx(
          typeCoin: typeCoin, amount: double.parse(amount), fee: fee);
      await GetIt.I.get<SessionRepository>().client!.sendFunctions.sendTrx(
            isToken: _isToken,
            addressTo:
                _isBech ? AddressService.bech32ToHex(addressTo) : addressTo,
            amount: amount,
            coin: typeCoin,
            credentials: _credentials,
          );
      onSuccess(true);
    } on SocketException catch (_) {
      onError("Lost connection to server");
    } on RPCError catch (e, trace) {
      print('sendTransaction RPCError: $e\n$trace');
      onError(e.message);
    } on FormatException catch (e, trace) {
      print('sendTransaction FormatException: $e\n$trace');
      onError(e.message);
    } catch (e, trace) {
      print('sendTransaction: $e\n$trace');
      onError(e.toString());
    }
  }
}
