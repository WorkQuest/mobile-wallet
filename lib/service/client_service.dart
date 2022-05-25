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
import 'package:workquest_wallet_app/service/address_service.dart';
import 'package:workquest_wallet_app/ui/transfer_page/confirm_page/mobx/confirm_transfer_store.dart';
import 'package:workquest_wallet_app/utils/coins.dart';

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

  Future<String> getNetwork();

  Future sendTransaction({
    required String privateKey,
    required String addressTo,
    required String amount,
    required TYPE_COINS coin,
  });
}

class ClientService implements ClientServiceI {

  Web3Client? ethClient;

  ClientService(ConfigNetwork config) {
    try {
      print('config rpc: ${config.rpc}');
      ethClient = Web3Client(config.rpc, Client(), socketConnector: () {
        return IOWebSocketChannel.connect(config.wss).cast<String>();
      });
    } catch (e, trace) {
      print('e -> $e\ntrace -> $trace');
    }
  }

  @override
  Future<EthPrivateKey> getCredentials(String privateKey) async {
    return EthPrivateKey.fromHex(privateKey);
  }

  @override
  Future sendTransaction({
    required String privateKey,
    required String addressTo,
    required String amount,
    required TYPE_COINS coin,
  }) async {
    print('client sendTransaction');
    addressTo = addressTo.toLowerCase();
    String? hash;
    final bigInt = BigInt.from(double.parse(amount) * pow(10, 18));
    final credentials = await getCredentials(privateKey);
    final myAddress = await AddressService().getPublicAddress(privateKey);

    if (coin == TYPE_COINS.wqt) {
      hash = await ethClient!.sendTransaction(
        credentials,
        Transaction(
          to: EthereumAddress.fromHex(addressTo),
          from: myAddress,
          value: EtherAmount.fromUnitAndValue(
            EtherUnit.wei,
            bigInt,
          ),
        ),
        chainId: 20220112,
      );
    } else {
      String addressToken = CoinsUtils.getAddressCoin(coin, AccountRepository().getConfigNetwork().addresses);
      print('send ${coin.toString()}');
      final degree = coin == TYPE_COINS.usdt ? 6 : 18;
      final contract =
          Erc20(address: EthereumAddress.fromHex(addressToken), client: ethClient!);
      hash = await contract.transfer(
        // myAddress,
        EthereumAddress.fromHex(addressTo),
        BigInt.from(double.parse(amount) * pow(10, degree)),
        credentials: credentials,
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
  Future<double> getBalanceFromContract(String address) async {
    try {
      address = address.toLowerCase();
      final contract =
          Erc20(address: EthereumAddress.fromHex(address), client: ethClient!);
      final balance = await contract.balanceOf(
          EthereumAddress.fromHex(AccountRepository().userWallet!.address!));
      final addresses = AccountRepository().getConfigNetwork().addresses;
      if (address == addresses.usdt) {
        return balance.toDouble() * pow(10, -6);
      } else {
        return balance.toDouble() * pow(10, -18);
      }
    } catch (e) {
      return 0;
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

  @override
  Erc20 getContract(String address) {
    address = address.toLowerCase();
    return Erc20(address: EthereumAddress.fromHex(address), client: ethClient!);
  }
}
