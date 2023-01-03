import 'package:decimal/decimal.dart';
import 'package:get_it/get_it.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/model/transactions_response.dart';
import 'package:workquest_wallet_app/repository/session_repository.dart';
import 'package:workquest_wallet_app/ui/wallet_page/transactions/mobx/transactions_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/mobx/wallet_store.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';
import 'package:workquest_wallet_app/service/address_service.dart';

abstract class SendFunctionsI {
  Future<String> sendTrx({
    required bool isToken,
    required String addressTo,
    required String amount,
    required TokenSymbols coin,
    required EthPrivateKey credentials,
  });

  Future<String> sendNative({
    required String amount,
    required String addressTo,
    required EthPrivateKey credentials,
    required EtherAmount gasPrice,
  });

  Future<String> sendToken({
    required String amount,
    required String addressTo,
    required EthPrivateKey credentials,
    required TokenSymbols coin,
    required EtherAmount gasPrice,
    required EthereumAddress fromAddress,
  });
}

class SendFunctions implements SendFunctionsI {
  final Web3Client _web3client;

  SendFunctions(this._web3client);

  @override
  Future<String> sendTrx({
    required bool isToken,
    required String addressTo,
    required String amount,
    required TokenSymbols coin,
    required EthPrivateKey credentials,
  }) async {
    late String _hash;
    String _addressToken = '';
    int _degree = 18;
    final _gasPrice = await _getGasPrice();
    final _fromAddress = EthereumAddress.fromHex(GetIt.I.get<SessionRepository>().userAddress);
    if (isToken) {
      _addressToken = Web3Utils.getAddressToken(coin);
      final contract = Erc20(address: EthereumAddress.fromHex(_addressToken), client: _web3client);
      _degree = await Web3Utils.getDegreeToken(contract);
      _hash = await sendToken(
        coin: coin,
        amount: amount,
        gasPrice: _gasPrice,
        addressTo: addressTo,
        credentials: credentials,
        fromAddress: _fromAddress,
      );
    } else {
      _hash = await sendNative(
        amount: amount,
        addressTo: addressTo,
        credentials: credentials,
        gasPrice: _gasPrice,
      );
    }
    final _tx = _setTx(
        hash: _hash,
        isToken: isToken,
        addressToken: _addressToken,
        addressTo: addressTo,
        amount: amount,
        degree: _degree);
    GetIt.I.get<TransactionsStore>().addTransaction(_tx);
    GetIt.I.get<WalletStore>().getCoins(isForce: false);
    return _hash;
  }

  @override
  Future<String> sendNative({
    required String amount,
    required String addressTo,
    required EthPrivateKey credentials,
    required EtherAmount gasPrice,
  }) async {
    final _value = EtherAmount.fromUnitAndValue(
      EtherUnit.wei,
      (Decimal.parse(amount) * Decimal.fromInt(10).pow(18)).toBigInt(),
    );
    final _to = EthereumAddress.fromHex(addressTo);
    final _from = EthereumAddress.fromHex(GetIt.I.get<SessionRepository>().userAddress);
    final _chainId = await _web3client.getChainId();
    final hash = await _web3client.sendTransaction(
      credentials,
      Transaction(
        to: _to,
        from: _from,
        value: _value,
        gasPrice: gasPrice,
      ),
      chainId: _chainId.toInt(),
    );
    await _waitingTrx(hashTx: hash);
    return hash;
  }

  @override
  Future<String> sendToken({
    required String amount,
    required String addressTo,
    required EthPrivateKey credentials,
    required TokenSymbols coin,
    required EtherAmount gasPrice,
    required EthereumAddress fromAddress,
  }) async {
    String _addressToken = Web3Utils.getAddressToken(coin);
    final contract = Erc20(
      address: EthereumAddress.fromHex(_addressToken),
      client: _web3client,
    );
    final degree = await Web3Utils.getDegreeToken(contract);
    final hash = await contract.transfer(
      EthereumAddress.fromHex(addressTo),
      BigInt.parse((Decimal.parse(amount) * Decimal.fromInt(10).pow(degree)).toString()),
      credentials: credentials,
      transaction: Transaction(
        from: fromAddress,
        gasPrice: gasPrice,
      ),
    );
    await _waitingTrx(hashTx: hash);
    return hash;
  }

  Future<String> _waitingTrx({required String hashTx}) async {
    int attempts = 0;
    TransactionReceipt? result;
    while (result == null) {
      result = await _web3client.getTransactionReceipt(hashTx);
      await Future.delayed(const Duration(seconds: 3));
      attempts++;
      if (attempts == 100) {
        // final _link = Web3Utils.getLinkToExplorerFromSwap(network!, _txHashApprove);
        throw const FormatException("The waiting time is over. Expect a balance update.");
      }
    }
    return hashTx;
  }

  Future<EtherAmount> _getGasPrice() async {
    final _gas = await _web3client.getGasPrice();
    final _isETH = Web3Utils.isETH();
    final _gasPrice = EtherAmount.fromUnitAndValue(
      EtherUnit.wei,
      ((Decimal.fromBigInt(_gas.getInWei) * Decimal.parse(_isETH ? '1.05' : '1.0')).toBigInt()),
    );
    return _gasPrice;
  }

  Tx _setTx({
    required String hash,
    required bool isToken,
    required String addressToken,
    required String addressTo,
    required String amount,
    required int degree,
  }) =>
      Tx(
        hash: hash,
        fromAddressHash: AddressHash(
          bech32: AddressService.hexToBech32(GetIt.I.get<SessionRepository>().userAddress),
          hex: GetIt.I.get<SessionRepository>().userAddress,
        ),
        toAddressHash: AddressHash(
          bech32: AddressService.hexToBech32(addressTo),
          hex: addressTo,
        ),
        token_contract_address_hash: isToken
            ? AddressHash(
                bech32: AddressService.hexToBech32(addressToken),
                hex: addressToken,
              )
            : null,
        amount: (Decimal.parse(amount) * Decimal.fromInt(10).pow(degree)).toString(),
        insertedAt: DateTime.now(),
        block: Block(timestamp: DateTime.now()),
        tokenTransfers: !isToken
            ? null
            : [
                TokenTransfer(
                  amount: (Decimal.parse(amount) * Decimal.fromInt(10).pow(degree)).toString(),
                ),
              ],
      );
}
