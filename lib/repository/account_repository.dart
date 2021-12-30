import 'package:web3dart/web3dart.dart';
import 'package:workquest_wallet_app/service/address_service.dart';
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
    final result =
        await client!.getAllBalance(userAddresses!.first.privateKey!);
  }

  sendTransaction() async {
    final privateKey = userAddresses!.first.privateKey!;
    try {
      var credentials = await client!.getCredentials(privateKey);
      final myAddress = await AddressService.getPublicAddress(privateKey);
      final sign = await client!.ethClient!.signTransaction(
        credentials,
        Transaction(
          to: EthereumAddress.fromHex(
              '0x7DE3565289Fb5617cA6A642CCE01097DB23Be120'),
          from: myAddress,
          gasPrice: EtherAmount.inWei(BigInt.one),
          value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 100),
        ),
        chainId: 20211224
      );

      final result = await client!.ethClient!.sendRawTransaction(sign);
      await Future.delayed(const Duration(seconds: 15));
      final receipt = await client!.ethClient!.getTransactionReceipt(result);

    } catch (e, trace) {
      print('e -> $e, \n trace -> $trace');
    }
  }
  // 0xcb28c869cc6cc6b7408627a45b0dac326aaec630
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
