import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/ui/sign_up_page/sign_up_confirm/mobx/sign_up_confirm_store.dart';
import 'package:workquest_wallet_app/ui/splash_page/splash_page.dart';
import 'package:workquest_wallet_app/ui/wallet_page/transactions/mobx/transactions_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/mobx/wallet_store.dart';
import 'package:workquest_wallet_app/utils/storage.dart';

BuildContext? globalContext;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await EasyLocalization.ensureInitialized();
  GetIt.I.registerSingleton<TransactionsStore>(TransactionsStore());
  GetIt.I.registerSingleton<SignUpConfirmStore>(SignUpConfirmStore());
  GetIt.I.registerSingleton<WalletStore>(WalletStore());
  try {

    final wallet = await Storage.readWallet();
    final configName = await Storage.read(StorageKeys.configName.toString());
    if (wallet != null) {
      AccountRepository().setWallet(wallet);
    }
    if (configName != null) {
      AccountRepository().setNetwork(configName);
    } else {
      AccountRepository().setNetwork(ConfigNameNetwork.devnet.name);
    }
  } catch (e) {
    Storage.deleteAllFromSecureStorage();
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(EasyLocalization(
    child: const MyApp(),
    supportedLocales: const [
      Locale('en', 'US'),
      Locale('ru', 'RU'),
      Locale('ar', 'SA'),
    ],
    path: 'assets/lang',
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  bool get hasAccount => AccountRepository().userWallet != null;

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'WorkQuest Wallet',
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      builder: (context, child) {
        /// Set app text scale between 90% and 110%
        final mq = MediaQuery.of(context);
        double fontScale = mq.textScaleFactor.clamp(0.8, 1.0);
        return MediaQuery(
          data: mq.copyWith(textScaleFactor: fontScale),
          child: child!,
        );
      },
      home: const SplashPage(),
    );
  }
}
