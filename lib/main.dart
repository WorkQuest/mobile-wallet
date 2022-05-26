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
import 'package:workquest_wallet_app/widgets/banner/CustomBanner.dart';

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
    if (wallet != null) {
      AccountRepository().setWallet(wallet);
      final configName = await Storage.read(StorageKeys.configName.toString());
      AccountRepository().setNetwork(configName!);
    }
  } catch (e) {
    AccountRepository().clearData();
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
    return ValueListenableBuilder<ConfigNameNetwork?>(
      valueListenable: AccountRepository().notifier,
      builder: (_, value, child) {
        final name = value?.name ?? ConfigNameNetwork.devnet.name;
        final visible = name != ConfigNameNetwork.devnet.name;
        return CustomBanner(
          text: '${name.substring(0,1).toUpperCase()}${name.substring(1)}',
          visible: false,
          color: visible ? AppColor.blue : Colors.transparent,
          textStyle: visible
              ? const TextStyle(color:  AppColor.enabledText, fontWeight: FontWeight.bold)
              : const TextStyle(color: Colors.transparent, fontWeight: FontWeight.bold),
          child: child!,
        );
      },
      child: MaterialApp(
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
      ),
    );
  }
}
