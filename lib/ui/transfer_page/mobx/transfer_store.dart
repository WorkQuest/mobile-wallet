import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:decimal/decimal.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/session_repository.dart';
import 'package:workquest_wallet_app/service/address_service.dart';
import 'package:workquest_wallet_app/ui/transfer_page/transfer_page.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';

part 'transfer_store.g.dart';

class TransferStore = TransferStoreBase with _$TransferStore;

abstract class TransferStoreBase extends IStore<TransferStoreState> with Store {
  @observable
  double? maxAmount;

  @observable
  String addressTo = '';

  @observable
  String amount = '';

  @observable
  String fee = '';

  @observable
  CoinItem? currentCoin;

  @computed
  bool get statusButtonTransfer =>
      currentCoin != null && addressTo.isNotEmpty && amount.isNotEmpty;

  @action
  setFee(String value) => fee = value;

  @action
  setAddressTo(String value) => addressTo = value;

  @action
  setAmount(String value) {
    if (value.isNotEmpty) {
      getFee();
    }
    amount = value;
  }

  @action
  setCoin(CoinItem? value) async {
    maxAmount = null;
    currentCoin = value;
    if (value != null) {
      getFee();
      maxAmount = double.parse(await _getMaxAmount());
    }
  }

  @action
  getMaxAmount() async {
    onLoading();
    try {
      amount = await _getMaxAmount();
      onSuccess(TransferStoreState.getMaxAmount);
    } on SocketException catch (_) {
      onError("Lost connection to server");
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      print('e: $e');
      onError(e.toString());
    }
  }

  @action
  getFee() async {
    print('getFee');
    if (currentCoin == null) {
      return;
    }
    try {
      final _client = GetIt.I.get<SessionRepository>().getClient();
      final _from =
          EthereumAddress.fromHex(GetIt.I.get<SessionRepository>().userAddress);
      String _amount = amount.isEmpty ? '1.0' : amount;
      String _address = AddressService.convertToHexAddress(
        addressTo.isEmpty
            ? GetIt.I.get<SessionRepository>().userAddress
            : addressTo,
      );
      final _gas = await _client.getGas();

      final _currentListTokens =
          GetIt.I.get<SessionRepository>().getConfigNetwork().dataCoins;
      final _isToken =
          currentCoin!.typeCoin != _currentListTokens.first.symbolToken;

      if (_isToken) {
        String _addressToken = Web3Utils.getAddressToken(currentCoin!.typeCoin);
        print('_addressToken: $_addressToken');
        final _contract = Erc20(
          address: EthereumAddress.fromHex(_addressToken),
          client: _client.ethClient!,
        );
        final _degree = await Web3Utils.getDegreeToken(_contract);
        final _estimateGas = await _client.getEstimateGas(
          Transaction.callContract(
            contract: _contract.self,
            function: _contract.self.abi.functions[7],
            parameters: [
              EthereumAddress.fromHex(_address),
              Web3Utils.getAmountBigInt(amount: _amount, degree: _degree),
            ],
            from: _from,
          ),
        );
        fee = Web3Utils.getGas(
          estimateGas: _estimateGas,
          gas: _gas.getInWei,
          degree: 18,
          isETH: Web3Utils.isETH(),
          isTransfer: true,
        ).toStringAsFixed(18);
      } else {
        final _value = EtherAmount.fromUnitAndValue(
          EtherUnit.wei,
          Web3Utils.getAmountBigInt(amount: _amount, degree: 18),
        );
        final _to = EthereumAddress.fromHex(_address);
        final _estimateGas = await _client.getEstimateGas(
          Transaction(
            to: _to,
            from: _from,
            value: _value,
          ),
        );
        fee = Web3Utils.getGas(
          estimateGas: _estimateGas,
          gas: _gas.getInWei,
          degree: 18,
          isETH: Web3Utils.isETH(),
          isTransfer: true,
        ).toStringAsFixed(18);
      }
    } on SocketException catch (_) {
      // onError("Lost connection to server");
    } catch (e, trace) {
      print('e: $e\n$trace');
      // onError(e.toString());
    }
  }

  @action
  checkBeforeSend({bool isTimerUpdate = false}) async {
    if (isTimerUpdate) {
      await getFee();
      print('fee: $fee');
      maxAmount = double.parse(await _getMaxAmount());
      return;
    }
    try {
      onLoading();
      await getFee();
      print('fee: $fee');
      maxAmount = double.parse(await _getMaxAmount());
      onSuccess(TransferStoreState.checkBeforeSend);
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  clearData() {
    addressTo = '';
    amount = '';
    fee = '';
    currentCoin = null;
  }

  Future<String> _getMaxAmount() async {
    final _client = GetIt.I.get<SessionRepository>().getClient();
    final _dataCoins =
        GetIt.I.get<SessionRepository>().getConfigNetwork().dataCoins;
    final _isNotToken = _dataCoins
            .firstWhere(
                (element) => element.symbolToken == currentCoin!.typeCoin)
            .addressToken ==
        null;
    if (_isNotToken) {
      final _balance = await _client.getBalance();
      final _balanceInWei = _balance.getInWei;
      await getFee();
      final _gas = Decimal.parse(fee) * Decimal.fromInt(10).pow(18);
      final _amount = ((Decimal.parse(_balanceInWei.toString()) -
                  (_gas *
                      Decimal.parse(Commission.percentTransfer.toString()))) /
              Decimal.fromInt(10).pow(18))
          .toDecimal();
      if (_amount < Decimal.zero) {
        return 0.0.toString();
      } else {
        return _amount.toString();
      }
    }

    final _balance = await GetIt.I
        .get<SessionRepository>()
        .getClient()
        .getBalanceFromContract(
            Web3Utils.getAddressToken(currentCoin!.typeCoin));
    return _balance.toStringAsFixed(18);
  }
}

enum TransferStoreState { checkBeforeSend, getMaxAmount }
