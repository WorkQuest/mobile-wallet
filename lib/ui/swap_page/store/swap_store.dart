import 'dart:math';

import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';

import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/http/api.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/service/client_service.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';

part 'swap_store.g.dart';

enum SwapNetworks { ETH, BSC, POLYGON }

enum SwapToken { tusdt, usdc }

class SwapStore = SwapStoreBase with _$SwapStore;

abstract class SwapStoreBase extends IStore<SuccessStatus> with Store {
  ClientService? service;

  double? courseWQT;

  @observable
  SwapNetworks? network;

  @observable
  SwapToken token = SwapToken.tusdt;

  @observable
  double amount = 0.0;

  @observable
  double? maxAmount;

  @observable
  bool isConnect = false;

  @observable
  double? convertWQT;

  @observable
  bool isLoadingCourse = false;

  @observable
  bool isSuccessCourse = false;

  @action
  clearData() {
    if (service != null) {
      service?.ethClient?.dispose();
    }
    service = null;
    courseWQT = null;
    network = null;
    amount = 0.0;
    maxAmount = null;
    isConnect = false;
    convertWQT = null;
    isLoadingCourse = false;
    isSuccessCourse = false;
  }

  @action
  setNetwork(SwapNetworks? value, {bool showing = true}) async {
    try {
      onLoading();
      network = value;
      maxAmount = null;
      convertWQT = null;
      isSuccessCourse = false;
      if (value == null) {
        isLoading = false;
        return;
      }
      await _connectRpc();
      isConnect = true;
      onSuccess(showing ? SuccessStatus.showing : SuccessStatus.notShowing);
    } catch (e) {
      isConnect = false;
      onError(e.toString(),
          showing ? SuccessStatus.showing : SuccessStatus.notShowing);
    }
  }

  @action
  setToken(SwapToken value) => token = value;

  @action
  setAmount(double value) => amount = value;

  @action
  getMaxBalance() async {
    maxAmount = await service!.getBalanceFromContract(
        Web3Utils.getTokenUSDTForSwap(network!),
        otherNetwork: true);
  }

  @action
  getCourseWQT({bool isForce = false}) async {
    isLoadingCourse = true;
    isSuccessCourse = false;
    try {
      courseWQT ??= await Api().getCourseWQT();
      if (isForce) {
        courseWQT = await Api().getCourseWQT();
      }
      convertWQT = (amount / courseWQT!) * (1 - 0.01);
      isSuccessCourse = true;
    } catch (e) {
      onError(e.toString(), SuccessStatus.showing);
    }
    isLoadingCourse = false;
  }

  @action
  createSwap(String address) async {
    try {
      onLoading();
      Web3Client _client = service!.ethClient!;
      final _address = AccountRepository().userWallet!.address!;
      final _privateKey = AccountRepository().userWallet!.privateKey!;
      final _nonce =
          await _client.getTransactionCount(EthereumAddress.fromHex(_address));
      final _cred = await service!.getCredentials(_privateKey);
      final _gas = await service!.getGas();
      final _chainId = await service!.ethClient!.getChainId();
      final _contract = await _getContract();
      print('price: $amount');
      await _approve();
      final _hashTx = await _client.sendTransaction(
        _cred,
        Transaction.callContract(
          from: EthereumAddress.fromHex(_address),
          contract: _contract,
          function: _contract.function('swap'),
          gasPrice: _gas,
          maxGas: 2000000,
          parameters: [
            ///nonce uint256
            BigInt.from(_nonce),

            ///chainTo uint256
            BigInt.from(1.0),

            ///amount uint256
            BigInt.from(amount * pow(10, 6)),

            ///recipient address
            EthereumAddress.fromHex(address),

            ///userId string
            '1',

            ///symbol string
            'USDT'
          ],
        ),
        chainId: _chainId.toInt(),
      );
      int _attempts = 0;
      while (_attempts < 8) {
        final result = await _client.getTransactionReceipt(_hashTx);
        if (result != null) {
          getMaxBalance();
          onSuccess(SuccessStatus.showing);
          return;
        }
        await Future.delayed(const Duration(seconds: 3));
        _attempts++;
      }
      getMaxBalance();
      onError('Waiting time has expired', SuccessStatus.showing);
    } catch (e, trace) {
      print('createSwap | e: $e\ntrace: $trace');
      onError(e.toString(), SuccessStatus.showing);
    }
  }

  _connectRpc() async {
    if (service != null) {
      service!.ethClient?.dispose();
      service!.ethClient = null;
      service = null;
    }
    service = ClientService(
      Configs.configsNetwork[NetworkName.workNetMainnet]!,
      customRpc: Web3Utils.getRpcNetworkForSwap(network!),
    );
    await Future.delayed(const Duration(seconds: 2));
    await getMaxBalance();
  }

  _approve() async {
    final contract = Erc20(
        address:
            EthereumAddress.fromHex(Web3Utils.getTokenUSDTForSwap(network!)),
        client: service!.ethClient!);

    print('address: ${AccountRepository().userWallet!.address!}');
    final _cred = await service!
        .getCredentials(AccountRepository().userWallet!.privateKey!);
    print('address: ${_cred.address}');
    final _spender = EthereumAddress.fromHex(
      Web3Utils.getAddressContractForSwap(network!),
    );
    final _gas = await service!.getGas();
    await contract.approve(_spender, BigInt.from(amount * pow(10, 6)),
        credentials: _cred,
        transaction: Transaction(
          gasPrice: _gas,
          maxGas: 2000000,
          value: EtherAmount.zero(),
        ));
  }

  Future<DeployedContract> _getContract() async {
    final _abiJson =
        await rootBundle.loadString("assets/contracts/WQBridge.json");
    final _contractAbi = ContractAbi.fromJson(_abiJson, 'WQBridge');
    final _contractAddress =
        EthereumAddress.fromHex(Web3Utils.getAddressContractForSwap(network!));
    return DeployedContract(_contractAbi, _contractAddress);
  }
}

enum SuccessStatus { showing, notShowing }
