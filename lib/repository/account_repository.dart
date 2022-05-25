import 'package:get_it/get_it.dart';
import 'package:workquest_wallet_app/service/client_service.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/mobx/wallet_store.dart';
import 'package:workquest_wallet_app/utils/wallet.dart';

import '../constants.dart';
import '../ui/wallet_page/transactions/mobx/transactions_store.dart';
import '../utils/storage.dart';

class AccountRepository {
  static final AccountRepository _instance = AccountRepository._internal();

  factory AccountRepository() => _instance;

  AccountRepository._internal();

  Wallet? userWallet;
  ClientService? client;
  ConfigNameNetwork? configName;

  String get privateKey => userWallet!.privateKey!;

  connectClient() {
    final config = Configs.configsNetwork[configName];
    client = ClientService(config!);
  }

  setNetwork(String name) {
    final configName = _getNetworkNameKey(name);
    print('configName: $configName');
    this.configName = configName;
  }

  changeNetwork(ConfigNameNetwork configName) {
    _saveNetwork(configName);
    _disconnectWeb3Client();
    connectClient();
    GetIt.I.get<TransactionsStore>().getTransactions();
    GetIt.I.get<WalletStore>().getCoins();
  }

  setWallet(Wallet wallet) {
    userWallet = wallet;
  }

  clearData() {
    userWallet = null;
    configName = null;
    _disconnectWeb3Client();
    _deleteNetwork();
  }

  ConfigNetwork getConfigNetwork() {
    return Configs.configsNetwork[configName]!;
  }

  _saveNetwork(ConfigNameNetwork configName) {
    this.configName = configName;
    Storage.write(StorageKeys.configName.toString(), configName.name);
  }

  _deleteNetwork() => Storage.delete(StorageKeys.configName.toString());

  _disconnectWeb3Client() {
    if (client!.ethClient != null) {
      client!.ethClient!.dispose();
      client!.ethClient = null;
    }
  }

  ConfigNameNetwork _getNetworkNameKey(String name) {
    switch (name) {
      case 'devnet':
        return ConfigNameNetwork.devnet;
      case 'testnet':
        return  ConfigNameNetwork.testnet;
      default:
        throw Exception('Unknown name network');
    }
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
