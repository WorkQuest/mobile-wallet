import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/http/web_socket.dart';
import 'package:workquest_wallet_app/service/client_service.dart';
import 'package:workquest_wallet_app/ui/swap_page/store/swap_store.dart';
import 'package:workquest_wallet_app/ui/transfer_page/mobx/transfer_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/transactions/mobx/transactions_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/mobx/wallet_store.dart';
import 'package:workquest_wallet_app/utils/storage.dart';
import 'package:workquest_wallet_app/utils/wallet.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';

class SessionRepository {
  Wallet? userWallet;
  ClientService? client;

  ValueNotifier<NetworkName?> networkName = ValueNotifier<NetworkName?>(null);
  ValueNotifier<Network> notifierNetwork =
      ValueNotifier<Network>(Network.mainnet);

  String get userAddress => userWallet!.address!;

  bool get isOtherNetwork =>
      networkName.value != NetworkName.workNetTestnet &&
      networkName.value != NetworkName.workNetMainnet;

  ClientService getClient() {
    return client!;
  }

  connectClient() {
    final config = Configs.configsNetwork[networkName.value!];
    client = ClientService(config!);
  }

  ConfigNetwork getConfigNetwork() {
    return Configs.configsNetwork[networkName.value!]!;
  }

  ConfigNetwork getConfigNetworkWorknet() {
    final _isTestnet = notifierNetwork.value == Network.testnet;
    return Configs.configsNetwork[
        _isTestnet ? NetworkName.workNetTestnet : NetworkName.workNetMainnet]!;
  }

  setNetwork(NetworkName networkName) {
    this.networkName.value = networkName;
    final _network = Web3Utils.getNetwork(networkName);
    notifierNetwork.value = _network;
  }

  changeNetwork(NetworkName networkName, {bool updateTrxList = false}) {
    _saveNetwork(networkName);
    _disconnectWeb3Client();
    WebSocket().reconnectWalletSocket();
    connectClient();
    GetIt.I.get<WalletStore>().getCoins(isForce: true, fromSwap: updateTrxList);
    GetIt.I.get<TransferStore>().setCoin(null);
  }

  setWallet(Wallet wallet) {
    userWallet = wallet;
    Storage.write(StorageKeys.privateKey.name, wallet.privateKey!);
  }

  clearData() {
    userWallet = null;
    networkName.value = null;
    notifierNetwork.value = Network.mainnet;
    _disconnectWeb3Client();
    GetIt.I.get<TransactionsStore>().clearData();
    GetIt.I.get<WalletStore>().clearData();
    GetIt.I.get<TransferStore>().clearData();
    GetIt.I.get<SwapStore>().clearData();
    Storage.deleteAllFromSecureStorage();
  }

  _saveNetwork(NetworkName networkName) {
    this.networkName.value = networkName;
    Storage.write(StorageKeys.networkName.name, networkName.name);
  }

  _disconnectWeb3Client() {
    client?.ethClient?.dispose();
    client?.ethClient = null;
    client?.stream?.cancel();
  }
}
