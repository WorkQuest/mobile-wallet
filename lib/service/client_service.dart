import 'dart:async';
import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:get_it/get_it.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/io.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/session_repository.dart';
import 'package:workquest_wallet_app/service/send_functions.dart';
import 'package:workquest_wallet_app/ui/swap_page/store/swap_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/mobx/wallet_store.dart';
import 'package:workquest_wallet_app/utils/storage.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';

abstract class ClientServiceI {
  Future<EtherAmount> getGas();
  Future<EtherAmount> getBalance();
  Future<EthPrivateKey> getCredentials();
  Future<Decimal> getBalanceFromContract(String address);
  Future<String> getSignature();
  Future<BigInt> getEstimateGas(Transaction transaction);
}

class ClientService implements ClientServiceI {
  Web3Client? ethClient;
  StreamSubscription<String>? stream;

  SendFunctions get sendFunctions => SendFunctions(ethClient!);

  ClientService(ConfigNetwork config) {
    try {
      ethClient = Web3Client(config.rpc, Client(), socketConnector: () {
        return IOWebSocketChannel.connect(config.wss).cast<String>();
      });
      if (GetIt.I.get<SessionRepository>().isOtherNetwork) {
        Future.delayed(const Duration(seconds: 2)).then((value) {
          try {
            final _stream = ethClient!.socketConnector!.call();
            _stream.sink.add("""
          {
            "jsonrpc": "2.0",
            "method": "eth_subscribe",
            "id": 1,
            "params": ["newHeads"]
          }
        """);
            stream = _stream.stream.listen(_updateToNewBlocks);
          } catch (e) {
            // print('ethClient!.socketConnector!.call | $e\n$trace');
          }
        });
      }
    } catch (e) {
      // print('e -> $e\ntrace -> $trace');
      throw Exception(e.toString());
    }
  }

  _updateToNewBlocks(dynamic event) {
    final _walletStore = GetIt.I.get<WalletStore>();
    if (!_walletStore.isLoading) {
      _walletStore.getCoins(isForce: false, fromSwap: true);
    }
    final _swapStore = GetIt.I.get<SwapStore>();
    if (_swapStore.network != null && !_swapStore.isLoading) {
      _swapStore.getMaxBalance();
    }
  }

  @override
  Future<EthPrivateKey> getCredentials() async {
    final _privateKey = await Storage.read(StorageKeys.privateKey.name);
    return EthPrivateKey.fromHex(_privateKey!);
  }

  @override
  Future<Decimal> getBalanceFromContract(String address) async {
    address = address.toLowerCase();
    try {
      final contract =
      Erc20(address: EthereumAddress.fromHex(address), client: ethClient!);
      final balance = await contract.balanceOf(EthereumAddress.fromHex(
          GetIt.I
              .get<SessionRepository>()
              .userWallet!
              .address!));
      final _degree = await Web3Utils.getDegreeToken(contract);
      return (Decimal.parse(balance.toString()) /
          Decimal.fromInt(10).pow(_degree))
          .toDecimal();
    } catch (e) {
      return Decimal.zero;
    }
  }

  @override
  Future<String> getSignature() async {
    final credentials = await getCredentials();
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
  Future<EtherAmount> getBalance() async {
    final credentials = await getCredentials();
    return ethClient!.getBalance(credentials.address);
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
}

class Web3Exception implements Exception {
  final String message;

  Web3Exception([this.message = 'Unknown Web3 error']);

  @override
  String toString() => message;
}
