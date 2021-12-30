import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/ui/splash_page/splash_page.dart';
import 'package:workquest_wallet_app/ui/wallet_page/transactions/mobx/transactions_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/mobx/wallet_store.dart';
import 'package:workquest_wallet_app/utils/storage.dart';
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  GetIt.I.registerSingleton<TransactionsStore>(TransactionsStore());
  GetIt.I.registerSingleton<WalletStore>(WalletStore());
  final addressActive = await Storage.read(Storage.activeAddress);

  if (addressActive != null) {
    final wallets = await Storage.readWallets();
    if (wallets.isNotEmpty) {
      AccountRepository().userAddresses = wallets;
    }
    AccountRepository().userAddress = addressActive;
  }


  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  bool get hasAccount => AccountRepository().userAddresses != null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WorkQuest Wallet',
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const SplashPage(),
      // home: hasAccount ? const MainPage() : const LoginPage(),
    );
  }
}
