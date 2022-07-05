import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:hex/hex.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/io.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';

abstract class ClientServiceI {
  Future<List<BalanceItem>> getBalanceFromList(List<EtherUnit> units, String privateKey);

  Future<num> getBalanceInUnit(EtherUnit unit, String privateKey);

  Future<List<BalanceItem>> getAllBalance(String privateKey);

  Future<EthPrivateKey> getCredentials(String privateKey);

  Future<double> getBalanceFromContract(String address);

  Future<EtherAmount> getBalance(String privateKey);

  Future<String> getSignature(String privateKey);

  Erc20 getContract(String address);

  Future<EtherAmount> getGas();

  Future<BigInt> getEstimateGas(Transaction transaction);

  Future sendTransaction({
    required bool isToken,
    required String addressTo,
    required String amount,
    required TokenSymbols coin,
  });
}

class ClientService implements ClientServiceI {
  Web3Client? ethClient;

  ClientService(ConfigNetwork config, {String? customRpc}) {
    try {
      if (customRpc != null) {
        ethClient = Web3Client(customRpc, Client());
        return;
      }
      ethClient = Web3Client(config.rpc, Client(), socketConnector: () {
        return IOWebSocketChannel.connect(config.wss).cast<String>();
      });
    } catch (e, trace) {
      print('e -> $e\ntrace -> $trace');
      throw Exception(e.toString());
    }
  }

  @override
  Future<EthPrivateKey> getCredentials(String privateKey) async {
    return EthPrivateKey.fromHex(privateKey);
  }

  @override
  Future sendTransaction({
    required bool isToken,
    required String addressTo,
    required String amount,
    required TokenSymbols coin,
  }) async {
    print('client sendTransaction');
    String? hash;
    final _privateKey = AccountRepository().privateKey;
    final _credentials = await getCredentials(_privateKey);
    if (!isToken) {
      final _value = EtherAmount.fromUnitAndValue(
        EtherUnit.wei,
        BigInt.from(double.parse(amount) * pow(10, 18)),
      );
      final _to = EthereumAddress.fromHex(addressTo);
      final _from = EthereumAddress.fromHex(AccountRepository().userAddress);
      hash = await ethClient!.sendTransaction(
        _credentials,
        Transaction(
          to: _to,
          from: _from,
          value: _value,
        ),
        chainId: 1991,
      );
    } else {
      String _addressToken = Web3Utils.getAddressToken(coin);
      final contract = Erc20(
        address: EthereumAddress.fromHex(_addressToken),
        client: ethClient!,
      );
      final _degree = await Web3Utils.getDegreeToken(contract);
      hash = await contract.transfer(
        EthereumAddress.fromHex(addressTo),
        BigInt.from(double.parse(amount) * pow(10, _degree)),
        credentials: _credentials,
      );
      print('${coin.toString()} hash - $hash');
    }

    int attempts = 0;
    TransactionReceipt? result;
    while (result == null) {
      result = await ethClient!.getTransactionReceipt(hash);
      if (result != null) {
        print('result - ${result.blockNumber}');
      }
      await Future.delayed(const Duration(seconds: 3));
      attempts++;
      if (attempts == 5) {
        throw Exception("The waiting time is over. Expect a balance update.");
      }
    }
  }

  @override
  Future<double> getBalanceFromContract(String address, {bool otherNetwork = false, bool isUSDT = false}) async {
    try {
      address = address.toLowerCase();
      final contract = Erc20(address: EthereumAddress.fromHex(address), client: ethClient!);
      final balance = await contract.balanceOf(EthereumAddress.fromHex(AccountRepository().userWallet!.address!));
      final _degree = await Web3Utils.getDegreeToken(contract);
      if (otherNetwork || isUSDT) {
        return balance.toDouble() * pow(10, -_degree);
      }

      return balance.toDouble() * pow(10, -_degree);
    } catch (e, trace) {
      print('e: $e\ntrace: $trace');
      throw Exception("Error connection to network");
    }
  }

  @override
  Future<String> getSignature(String privateKey) async {
    final credentials = await getCredentials(privateKey);
    final address = await credentials.extractAddress();
    final result = await credentials.signPersonalMessage(
      Uint8List.fromList(address.addressBytes),
    );
    return HEX.encode(result.toList());
  }

  @override
  Future<EtherAmount> getGas() async {
    return ethClient!.getGasPrice();
  }

  @override
  Future<EtherAmount> getBalance(String privateKey) async {
    final credentials = await getCredentials(privateKey);
    return ethClient!.getBalance(credentials.address);
  }

  @override
  Future<List<BalanceItem>> getBalanceFromList(List<EtherUnit> units, String privateKey) async {
    if (units.isEmpty) {
      throw Exception("List units is empty");
    }

    final list = await Stream.fromIterable(units).asyncMap((unit) async {
      final balance = await getBalanceInUnit(unit, privateKey);
      return BalanceItem(unit.name, balance.toString());
    }).toList();

    return list;
  }

  @override
  Future<List<BalanceItem>> getAllBalance(String privateKey) async {
    final list = await Stream.fromIterable(EtherUnit.values).asyncMap((unit) async {
      final balance = await getBalanceInUnit(unit, privateKey);
      return BalanceItem(unit.name, balance.toString());
    }).toList();
    return list;
  }

  @override
  Future<num> getBalanceInUnit(EtherUnit unit, String privateKey) async {
    final balance = await getBalance(privateKey);
    return balance.getValueInUnit(unit);
  }

  @override
  Future<BigInt> getEstimateGas(Transaction transaction) async {
    return await ethClient!.estimateGas(
      sender: transaction.from,
      to: transaction.to,
      gasPrice: transaction.gasPrice,
      value: transaction.value,
      data: transaction.data,
      amountOfGas: transaction.gasPrice?.getInWei,
    );
  }

  @override
  Erc20 getContract(String address) {
    address = address.toLowerCase();
    return Erc20(address: EthereumAddress.fromHex(address), client: ethClient!);
  }
}
