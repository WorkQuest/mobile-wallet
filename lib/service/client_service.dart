import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:hex/hex.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/service/address_service.dart';

class ClientService {
  final apiUrl = "https://dev-node-nyc3.workquest.co";

  Web3Client? ethClient;

  ClientService() {
    ethClient = Web3Client(apiUrl, Client());
  }

  Future<EthPrivateKey> getCredentials(String privateKey) async {
    return await ethClient!.credentialsFromPrivateKey(privateKey);
  }

  Future sendTransaction({
    required String privateKey,
    required String address,
    required String amount,
    required String titleCoin,
  }) async {
    print('client sendTransaction');
    double doubText = double.parse(amount);
    switch (titleCoin) {
      case "WUSD":
        break;
      case "WQT":
        doubText /= 0.038;
        break;
    }
    final bigInt = BigInt.from(doubText * pow(10, 18));
    final credentials = await getCredentials(privateKey);
    final myAddress = await AddressService.getPublicAddress(privateKey);
    final hash = await ethClient!.sendTransaction(
      credentials,
      Transaction(
        to: EthereumAddress.fromHex(address),
        from: myAddress,
        gasPrice: EtherAmount.inWei(BigInt.one),
        value: EtherAmount.fromUnitAndValue(
          EtherUnit.wei,
          bigInt,
        ),
      ),
      chainId: 20211224,
    );
    int attempts = 0;
    TransactionReceipt? result;
    while (result == null) {
      result = await ethClient!.getTransactionReceipt(hash);
      await Future.delayed(const Duration(seconds: 3));
      attempts++;
      if (attempts == 5) {
        throw Exception("The waiting time is over. Expect a balance update.");
      }
    }
  }

  Future<String> getSignature(String privateKey) async {
    final credentials = await getCredentials(privateKey);
    final address = await credentials.extractAddress();
    final result = await credentials.signPersonalMessage(
      Uint8List.fromList(address.addressBytes),
    );
    return HEX.encode(result.toList());
  }

  Future<EtherAmount> getGas() async {
    return ethClient!.getGasPrice();
  }

  Future<EtherAmount> getBalance(String privateKey) async {
    final credentials = await getCredentials(privateKey);
    return ethClient!.getBalance(credentials.address);
  }

  Future<List<BalanceItem>> getBalanceFromList(
      List<EtherUnit> units, String privateKey) async {
    if (units.isEmpty) {
      throw Exception("List units is empty");
    }

    final list = await Stream.fromIterable(units).asyncMap((unit) async {
      final balance = await getBalanceInUnit(unit, privateKey);
      return BalanceItem(unit.name, balance.toString());
    }).toList();

    return list;
  }

  Future<List<BalanceItem>> getAllBalance(String privateKey) async {
    final list =
        await Stream.fromIterable(EtherUnit.values).asyncMap((unit) async {
      final balance = await getBalanceInUnit(unit, privateKey);
      return BalanceItem(unit.name, balance.toString());
    }).toList();

    return list;
  }

  Future<num> getBalanceInUnit(EtherUnit unit, String privateKey) async {
    final balance = await getBalance(privateKey);
    return balance.getValueInUnit(unit);
  }

  Future<String> getNetwork() async {
    try {
      final index = await ethClient!.getNetworkId();
      switch (index) {
        case 1:
          return "Ethereum Mainnet";
        case 2:
          return "Morden Testnet (deprecated)";
        case 3:
          return "Ropsten Testnet";
        case 4:
          return "Rinkeby Testnet";
        case 42:
          return "Kovan Testnet";
        default:
          return "Unknown network";
      }
    } catch (e) {
      return "Network could not be identified";
    }
  }
}
