import 'dart:convert';
import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/http/api.dart';
import 'package:workquest_wallet_app/repository/session_repository.dart';
import 'package:workquest_wallet_app/service/client_service.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';

part 'swap_store.g.dart';

enum SwapNetworks { ETH, BSC, POLYGON }

enum SwapToken { usdt }

class SwapStore = SwapStoreBase with _$SwapStore;

abstract class SwapStoreBase extends IStore<SwapStoreState> with Store {
  double? courseWQT;

  String? hashWorknetTrx;

  bool shouldReconnect = true;
  IOWebSocketChannel? _notificationChannel;

  ClientService? service;

  @observable
  SwapNetworks? network;

  @observable
  SwapToken token = SwapToken.usdt;

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

  @computed
  bool get statusSend =>
      isSuccessCourse && maxAmount != null && isConnect && convertWQT != null;

  @action
  setToken(SwapToken value) => token = value;

  @action
  setAmount(double value) => amount = value;

  @action
  getMaxBalance() async {
    final _result = await service!
        .getBalanceFromContract(Web3Utils.getTokenUSDTForSwap(network!));
    maxAmount = _result.toDouble();
  }

  @action
  setNetwork(SwapNetworks value, {bool isForce = false}) async {
    service?.ethClient?.dispose();
    service?.ethClient = null;
    service?.stream?.cancel();
    try {
      onLoading();
      final _network = Web3Utils.getNetworkNameFromSwapNetworks(value);
      service = ClientService(Configs.configsNetwork[_network]!);
      network = value;
      maxAmount = null;
      isConnect = false;
      convertWQT = null;
      isSuccessCourse = false;
      final _networkName = Web3Utils.getNetworkNameFromSwapNetworks(network!);
      if (isForce) {
        GetIt.I.get<SessionRepository>().changeNetwork(_networkName);
      }
      await getMaxBalance();
      isConnect = true;
      onSuccess(SwapStoreState.setNetwork);
    } catch (e, trace) {
      print('setNetwork | $e\n$trace');
      isConnect = false;
      onError(e.toString());
    }
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
      convertWQT = (amount / courseWQT!) * Commission.commissionBuy;
      isSuccessCourse = true;
    } catch (e) {
      // print('getCourseWQT | $e\n$trace');
    }
    isLoadingCourse = false;
  }

  @action
  createSwap() async {
    hashWorknetTrx = null;
    shouldReconnect = true;
    try {
      print('createSwap');
      onLoading();
      Web3Client _client = service!.ethClient!;
      final _address = GetIt.I.get<SessionRepository>().userWallet!.address!;
      final _nonce =
          await _client.getTransactionCount(EthereumAddress.fromHex(_address));
      final _cred = await service!.getCredentials();
      final _gas = await service!.getGas();
      final _chainId = await service!.ethClient!.getChainId();
      final _contract = await _getContract();
      final _contractToken = Erc20(
        address:
            EthereumAddress.fromHex(Web3Utils.getTokenUSDTForSwap(network!)),
        client: service!.ethClient!,
      );
      final _degree = await Web3Utils.getDegreeToken(_contractToken);
      final _isEth = network! == SwapNetworks.ETH;
      print('_gas.getInWei: ${_gas.getInWei}');
      print('_gas new: ${EtherAmount.fromUnitAndValue(
        EtherUnit.wei,
        (Decimal.fromBigInt(_gas.getInWei) *
                Decimal.parse(_isEth ? '1.1' : '1.0'))
            .toBigInt(),
      ).getInWei}');
      final _hashTx = await _client.sendTransaction(
        _cred,
        Transaction.callContract(
          from: EthereumAddress.fromHex(_address),
          contract: _contract,
          function: _contract.function('swap'),
          gasPrice: EtherAmount.fromUnitAndValue(
            EtherUnit.wei,
            (Decimal.fromBigInt(_gas.getInWei) *
                    Decimal.parse(_isEth ? '1.1' : '1.0'))
                .toBigInt(),
          ),
          parameters: _setParameters(nonce: _nonce, degree: _degree),
        ),
        chainId: _chainId.toInt(),
      );
      _connectSocket();
      int _attempts = 0;
      while (_attempts < 140) {
        final result = await _client.getTransactionReceipt(_hashTx);
        print('result swap: $result');
        if (result != null && hashWorknetTrx != null) {
          shouldReconnect = false;
          _notificationChannel?.sink.close();
          onSuccess(SwapStoreState.createSwap);
          return;
        }
        await Future.delayed(const Duration(seconds: 3));
        _attempts++;
      }
      final _link = Web3Utils.getLinkToExplorerFromSwap(network!, _hashTx);
      shouldReconnect = false;
      _notificationChannel?.sink.close();
      onError(
          'Waiting time has expired\n\nYou can check the transaction status in the explorer: \n $_link');
    } catch (e) {
      // print('createSwap | e: $e\ntrace: $trace');
      onError(e.toString());
    }
  }

  approve() async {
    try {
      onLoading();
      print('approve');
      final contract = Erc20(
        address:
            EthereumAddress.fromHex(Web3Utils.getTokenUSDTForSwap(network!)),
        client: service!.ethClient!,
      );
      final _cred = await service!.getCredentials();
      final _spender = EthereumAddress.fromHex(
          Web3Utils.getAddressContractForSwap(network!));
      final _gas = await service!.getGas();
      final _degree = await Web3Utils.getDegreeToken(contract);
      final _isEth = network! == SwapNetworks.ETH;
      print('_gas.getInWei: ${_gas.getInWei}');
      print('_gas new: ${EtherAmount.fromUnitAndValue(
        EtherUnit.wei,
        (Decimal.fromBigInt(_gas.getInWei) *
                Decimal.parse(_isEth ? '1.1' : '1.0'))
            .toBigInt(),
      ).getInWei}');
      final _txHashApprove = await contract.approve(
        _spender,
        (Decimal.parse(amount.toString()) * Decimal.fromInt(10).pow(_degree))
            .toBigInt(),
        credentials: _cred,
        transaction: Transaction(
          gasPrice: EtherAmount.fromUnitAndValue(
            EtherUnit.wei,
            (Decimal.fromBigInt(_gas.getInWei) *
                    Decimal.parse(_isEth ? '1.1' : '1.0'))
                .toBigInt(),
          ),
          value: EtherAmount.zero(),
        ),
      );
      int _attempts = 0;
      while (_attempts < 140) {
        final result =
            await service!.ethClient!.getTransactionReceipt(_txHashApprove);
        print('result approve: $result');
        if (result != null) {
          getMaxBalance();
          onSuccess(SwapStoreState.approve);
          return;
        }
        await Future.delayed(const Duration(seconds: 3));
        _attempts++;
      }
      final _link =
          Web3Utils.getLinkToExplorerFromSwap(network!, _txHashApprove);
      onError(
          'Waiting time has expired\n\nYou can check the transaction status in the explorer: \n $_link');
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<bool> needApprove() async {
    final _contract = Erc20(
      address: EthereumAddress.fromHex(Web3Utils.getTokenUSDTForSwap(network!)),
      client: service!.ethClient!,
    );
    final _degree = await Web3Utils.getDegreeToken(_contract);
    final _amount = BigInt.from(amount * pow(10, _degree));
    final _spender =
        EthereumAddress.fromHex(Web3Utils.getAddressContractForSwap(network!));
    final _allowance = await _contract.allowance(
      EthereumAddress.fromHex(GetIt.I.get<SessionRepository>().userAddress),
      _spender,
    );
    if (_allowance < _amount) {
      return true;
    }
    return false;
  }

  Future<BigInt> amountToken() async {
    final _contract = Erc20(
      address: EthereumAddress.fromHex(Web3Utils.getTokenUSDTForSwap(network!)),
      client: service!.ethClient!,
    );
    final _degree = await Web3Utils.getDegreeToken(_contract);
    return BigInt.from(amount * pow(10, _degree));
  }

  Future<DeployedContract> _getContract() async {
    final _abiJson =
        await rootBundle.loadString("assets/contracts/WQBridge.json");
    final _contractAbi = ContractAbi.fromJson(_abiJson, 'WQBridge');
    final _contractAddress =
        EthereumAddress.fromHex(Web3Utils.getAddressContractForSwap(network!));
    return DeployedContract(_contractAbi, _contractAddress);
  }

  Future<String> getEstimateGasApprove() async {
    final _contract = Erc20(
      address: EthereumAddress.fromHex(Web3Utils.getTokenUSDTForSwap(network!)),
      client: service!.ethClient!,
    );
    final _cred = await service!.getCredentials();
    final _spender =
        EthereumAddress.fromHex(Web3Utils.getAddressContractForSwap(network!));
    final _degree = await Web3Utils.getDegreeToken(_contract);
    final _estimateGas = await service!.getEstimateGas(
      Transaction.callContract(
        contract: _contract.self,
        function: _contract.self.function('approve'),
        parameters: [
          _spender,
          (Decimal.parse(amount.toString()) * Decimal.fromInt(10).pow(_degree))
              .toBigInt()
        ],
        from: _cred.address,
      ),
    );
    final _gas = await service!.getGas();
    final _fee = Web3Utils.getGas(
      estimateGas: _estimateGas,
      gas: _gas.getInWei,
      degree: 18,
      isETH: network == SwapNetworks.ETH,
    );
    await Web3Utils.checkPossibilityTx(
        typeCoin: TokenSymbols.USDT, amount: amount, fee: _fee);
    return _fee.toStringAsFixed(17);
  }

  Future<String> getEstimateGasSwap() async {
    final _address = GetIt.I.get<SessionRepository>().userWallet!.address!;
    final _nonce = await service!.ethClient!
        .getTransactionCount(EthereumAddress.fromHex(_address));
    final _gas = await service!.getGas();
    final _contract = await _getContract();
    final _contractToken = Erc20(
      address: EthereumAddress.fromHex(Web3Utils.getTokenUSDTForSwap(network!)),
      client: service!.ethClient!,
    );
    final _degree = await Web3Utils.getDegreeToken(_contractToken);
    final _estimateGas = await service!.getEstimateGas(
      Transaction.callContract(
        from: EthereumAddress.fromHex(_address),
        contract: _contract,
        function: _contract.function('swap'),
        parameters: _setParameters(nonce: _nonce, degree: _degree),
      ),
    );
    final _fee = Web3Utils.getGas(
      estimateGas: _estimateGas,
      gas: _gas.getInWei,
      degree: 18,
      isETH: network == SwapNetworks.ETH,
    );
    await Web3Utils.checkPossibilityTx(
        typeCoin: TokenSymbols.USDT, amount: amount, fee: _fee);
    return ((_estimateGas * _gas.getInWei).toDouble() * pow(10, -18))
        .toStringAsFixed(17);
  }

  _connectSocket() {
    final _wsPath = GetIt.I.get<SessionRepository>().notifierNetwork.value ==
            Network.testnet
        ? 'wss://testnet-notification.workquest.co/api/v1/notifications'
        : 'wss://mainnet-notification.workquest.co/api/v1/notifications';
    _notificationChannel = IOWebSocketChannel.connect(_wsPath);

    _notificationChannel!.sink.add("""{
                  "type": "hello",
                  "id": 1,
                  "version": "2",                  
                  "auth": {
                      "headers": {"authorization": null}
                  },
                  "subs": ["/notifications/bridgeUsdt/${GetIt.I.get<SessionRepository>().userAddress}"]
                }""");

    _notificationChannel!.stream.listen(
      (message) {
        print('message connect: $message');
        try {
          final _response = jsonDecode(message);
          hashWorknetTrx = _response['message']['data']['hash'];
        } catch (e) {
          // print('catch socket: $e');
        }
      },
      onError: (error) {
        print('message error: $error');
      },
      onDone: () {
        print('done conntect');
        if (shouldReconnect) {
          _connectSocket();
        }
      },
    );
  }

  List<dynamic> _setParameters({
    required int nonce,
    required int degree,
  }) {
    return [
      ///nonce uint256
      BigInt.from(nonce),

      ///chainTo uint256
      BigInt.from(1.0),

      ///amount uint256
      BigInt.from(amount * pow(10, degree)),

      ///recipient address
      EthereumAddress.fromHex(GetIt.I.get<SessionRepository>().userAddress),

      ///userId string
      '1',

      ///symbol string
      'USDT'
    ];
  }

  @action
  clearData() {
    courseWQT = null;
    network = null;
    amount = 0.0;
    maxAmount = null;
    isConnect = false;
    convertWQT = null;
    isLoadingCourse = false;
    isSuccessCourse = false;
  }
}

enum SwapStoreState { setNetwork, createSwap, approve }
