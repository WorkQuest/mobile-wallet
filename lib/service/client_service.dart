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
import 'package:workquest_wallet_app/model/transactions_response.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/service/address_service.dart';
import 'package:workquest_wallet_app/ui/swap_page/store/swap_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/transactions/mobx/transactions_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/mobx/wallet_store.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';

abstract class ClientServiceI {
  Future<List<BalanceItem>> getBalanceFromList(List<EtherUnit> units, String privateKey);

  Future<num> getBalanceInUnit(EtherUnit unit, String privateKey);

  Future<List<BalanceItem>> getAllBalance(String privateKey);

  Future<EthPrivateKey> getCredentials(String privateKey);

  Future<Decimal> getBalanceFromContract(String address);

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
  StreamSubscription<String>? stream;

  ClientService(ConfigNetwork config) {
    try {
      ethClient = Web3Client(config.rpc, Client(), socketConnector: () {
        return IOWebSocketChannel.connect(config.wss).cast<String>();
      });
      if (AccountRepository().isOtherNetwork) {
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
            stream = _stream.stream.listen((event) {
              final _walletStore = GetIt.I.get<WalletStore>();
              if (!_walletStore.isLoading) {
                _walletStore.getCoins(isForce: false);
              }
              final _swapStore = GetIt.I.get<SwapStore>();
              if (_swapStore.network != null && !_swapStore.isLoading) {
                _swapStore.getMaxBalance();
              }
            });
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
    String? hash;
    int? degree;
    final _privateKey = AccountRepository().privateKey;
    final _credentials = await getCredentials(_privateKey);
    String _addressToken = Web3Utils.getAddressToken(coin);
    final _from = EthereumAddress.fromHex(AccountRepository().userAddress);
    final _gas = await getGas();
    final _isETH = Web3Utils.isETH();
    final _gasPrice = EtherAmount.fromUnitAndValue(
      EtherUnit.wei,
      ((Decimal.fromBigInt(_gas.getInWei) * Decimal.parse(_isETH ? '1.05' : '1.0'))
          .toBigInt()),
    );
    if (!isToken) {
      final _value = EtherAmount.fromUnitAndValue(
        EtherUnit.wei,
        BigInt.parse((Decimal.parse(amount) * Decimal.fromInt(10).pow(18)).toString()),
      );
      final _to = EthereumAddress.fromHex(addressTo);

      final _chainId = await ethClient!.getChainId();
      hash = await ethClient!.sendTransaction(
        _credentials,
        Transaction(
          to: _to,
          from: _from,
          value: _value,
          gasPrice: _gasPrice,
        ),
        chainId: _chainId.toInt(),
      );
    } else {
      final contract = Erc20(
        address: EthereumAddress.fromHex(_addressToken),
        client: ethClient!,
      );
      degree = await Web3Utils.getDegreeToken(contract);
      hash = await contract.transfer(
        EthereumAddress.fromHex(addressTo),
        BigInt.parse(
            (Decimal.parse(amount) * Decimal.fromInt(10).pow(degree)).toString()),
        credentials: _credentials,
        transaction: Transaction(
          from: _from,
          gasPrice: _gasPrice,
        ),
      );
    }
    print('hash: $hash');

    int attempts = 0;
    TransactionReceipt? result;
    while (result == null) {
      result = await ethClient!.getTransactionReceipt(hash);
      await Future.delayed(const Duration(seconds: 3));
      attempts++;
      if (attempts == 100) {
        // final _link = Web3Utils.getLinkToExplorerFromSwap(network!, _txHashApprove);
        throw const FormatException("The waiting time is over. Expect a balance update.");
      }
    }
    final _tx = Tx(
      hash: hash,
      fromAddressHash: AddressHash(
        bech32: AddressService.hexToBech32(AccountRepository().userAddress),
        hex: AccountRepository().userAddress,
      ),
      toAddressHash: AddressHash(
        bech32: AddressService.hexToBech32(isToken ? _addressToken : addressTo),
        hex: isToken ? _addressToken : addressTo,
      ),
      amount: isToken
          ? null
          : (Decimal.parse(amount) * Decimal.fromInt(10).pow(18)).toString(),
      insertedAt: DateTime.now(),
      block: Block(timestamp: DateTime.now()),
      tokenTransfers: !isToken
          ? null
          : [
              TokenTransfer(
                amount:
                    (Decimal.parse(amount) * Decimal.fromInt(10).pow(degree!)).toString(),
              ),
            ],
    );
    GetIt.I.get<TransactionsStore>().addTransaction(_tx);
  }

  @override
  Future<Decimal> getBalanceFromContract(String address) async {
    address = address.toLowerCase();
    final contract = Erc20(address: EthereumAddress.fromHex(address), client: ethClient!);
    final balance = await contract
        .balanceOf(EthereumAddress.fromHex(AccountRepository().userWallet!.address!));
    final _degree = await Web3Utils.getDegreeToken(contract);
    return (Decimal.parse(balance.toString()) / Decimal.fromInt(10).pow(_degree))
        .toDecimal();
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

class BalanceItem {
  String title;
  String amount;

  BalanceItem(this.title, this.amount);

  @override
  String toString() {
    return 'BalanceItem {title: $title, amount: $amount}';
  }
}
