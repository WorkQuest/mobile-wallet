import 'package:workquest_wallet_app/service/client_service.dart';
import 'package:workquest_wallet_app/utils/wallet.dart' as wal;

class AccountRepository {
  static final AccountRepository _instance = AccountRepository._internal();

  factory AccountRepository() => _instance;

  AccountRepository._internal() {
    client = ClientService();
  }

  ClientService? client;
  String? userAddress;
  List<wal.Wallet>? userAddresses;

  String get privateKey => userAddresses!.first.privateKey!;

  addWallet(wal.Wallet wallet) {
    if (userAddresses == null || userAddresses!.isEmpty) {
      userAddresses = [];
    }
    userAddresses!.add(wallet);
  }

  getAllBalances() async {
    await client!.getAllBalance(userAddresses!.first.privateKey!);
  }

  clearData() {
    userAddress = null;
    userAddresses!.clear();
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
