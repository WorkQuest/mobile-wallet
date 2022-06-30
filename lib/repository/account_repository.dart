import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:workquest_wallet_app/http/web_socket.dart';
import 'package:workquest_wallet_app/service/client_service.dart';
import 'package:workquest_wallet_app/ui/sign_up_page/sign_up_confirm/mobx/sign_up_confirm_store.dart';
import 'package:workquest_wallet_app/ui/swap_page/store/swap_store.dart';
import 'package:workquest_wallet_app/ui/transfer_page/mobx/transfer_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/mobx/wallet_store.dart';
import 'package:workquest_wallet_app/utils/wallet.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';

import '../constants.dart';
import '../ui/wallet_page/transactions/mobx/transactions_store.dart';
import '../utils/storage.dart';

class AccountRepository {
  static final AccountRepository _instance = AccountRepository._internal();

  factory AccountRepository() => _instance;

  AccountRepository._internal();

  Wallet? userWallet;

  ClientService? client;

  ValueNotifier<NetworkName?> networkName  = ValueNotifier<NetworkName?>(null);

  ValueNotifier<Network> notifierNetwork = ValueNotifier<Network>(Network.mainnet);

  String get userAddress => userWallet!.address!;

  String get privateKey => userWallet!.privateKey!;

  ClientService getClient() {
    return client!;
  }

  connectClient() {
    final config = Configs.configsNetwork[networkName.value!];
    client = ClientService(config!);
  }

  setNetwork(NetworkName networkName) {
    this.networkName.value = networkName;
    final _network = Web3Utils.getNetwork(networkName);
    notifierNetwork.value = _network;
  }

  changeNetwork(NetworkName networkName) {
    _saveNetwork(networkName);
    _disconnectWeb3Client();
    WebSocket().reconnectWalletSocket();
    connectClient();
    GetIt.I.get<TransactionsStore>().getTransactions();
    GetIt.I.get<WalletStore>().getCoins();
    GetIt.I.get<TransferStore>().setCoin(null);
    final _swapNetwork = Web3Utils.getSwapNetworksFromNetworkName(networkName);
    GetIt.I.get<SwapStore>().setNetwork(_swapNetwork, showing: false);
  }

  setWallet(Wallet wallet) {
    userWallet = wallet;
  }

  clearData() {
    userWallet = null;
    networkName.value = null;
    notifierNetwork.value = Network.mainnet;
    _disconnectWeb3Client();
    GetIt.I.get<TransactionsStore>().clearData();
    GetIt.I.get<SignUpConfirmStore>().clearData();
    GetIt.I.get<WalletStore>().clearData();
    GetIt.I.get<TransferStore>().clearData();
    Storage.deleteAllFromSecureStorage();
  }

  ConfigNetwork getConfigNetwork() {
    return Configs.configsNetwork[networkName.value!]!;
  }

  _saveNetwork(NetworkName networkName) {
    this.networkName.value = networkName;
    Storage.write(StorageKeys.networkName.toString(), networkName.name);
  }

  _disconnectWeb3Client() {
    if (client?.ethClient != null) {
      client!.ethClient!.dispose();
      client!.ethClient = null;
    }
  }

  bool get isOtherNetwork =>
      networkName.value != NetworkName.workNetTestnet &&
      networkName.value != NetworkName.workNetMainnet;

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
