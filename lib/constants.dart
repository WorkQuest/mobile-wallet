import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/keys.dart';

class Commission {
  static const commissionBuy = 0.98;
  static const percentTransfer = 1.01;
}

class Images {
  static const _imagePath = "assets/images";
  static const _svgPath = "assets/svg";

  static const loginImage = "$_imagePath/background_login_page.png";
  static const languageSettingsImage =
      "$_imagePath/language_settings_image.png";
  static const networkSettingsImage = "$_imagePath/network_settings_image.png";
  static const workerImage = "$_imagePath/worker_image.jpg";
  static const employerImage = "$_imagePath/employer_image.jpg";
  static const scanQRExample = "$_imagePath/scan_qr_example.png";

  static const wqLogo = "$_svgPath/wq_logo.svg";
  static const transferIconBar = "$_svgPath/transfer_icon_bar.svg";
  static const walletIconBar = "$_svgPath/wallet_icon_bar.svg";
  static const settingsIconBar = "$_svgPath/settings_icon_bar.svg";
  static const settingsLanguageIcon = "$_svgPath/settings_language_icon.svg";
  static const settingsNetworkIcon = "$_svgPath/settings_network_icon.svg";
  static const chooseCoinIcon = "$_svgPath/choose_coin_icon.svg";
  static const wbnbCoinIcon = "$_svgPath/wbnb_coin_icon.svg";
  static const wethCoinIcon = "$_svgPath/weth_coin_icon.svg";
  static const usdtCoinIcon = "$_svgPath/tusdt_coin_icon.svg";
  static const wqtCoinIcon = "$_svgPath/wqt_coin_icon.svg";
  static const wusdCoinIcon = "$_svgPath/wusd_coin_icon.svg";
  static const walletCopyIcon = "$_svgPath/wallet_copy_icon.svg";
  static const transactionStatusIcon = "$_svgPath/transaction_status_icon.svg";
  static const notCardsIcon = "$_svgPath/not_cards_icon.svg";
  static const hideNumberCardIcon = "$_svgPath/hide_number_card_icon.svg";
  static const profileIcon = "$_svgPath/profile_icon.svg";
  static const emailIcon = "$_svgPath/email_icon.svg";
  static const passwordIcon = "$_svgPath/password_icon.svg";
  static const biometricIcon = "$_svgPath/biometric_icon.svg";
  static const faceIdIcon = "$_svgPath/face_id.svg";
  static const removePinIcon = "$_svgPath/remove_pin_icon.svg";
  static const arrowDropDownIcon = "$_svgPath/arrow_dropdown_icon.svg";
  static const explorerToIcon = "$_svgPath/explorer_to_icon.svg";
  static const emptyListIcon = "$_svgPath/empty_list_icon.svg";
}

class AppColor {
  static const blue = Color(0xff103D7C);
  static const disabledText = Color(0xffD8DFE3);
  static const subtitleText = Color(0xff7C838D);
  static const enabledText = Colors.white;
  static const enabledButton = Color(0xff0083C7);
  static const disabledButton = Color(0xffF7F8FA);
  static const unselectedBottomIcon = Color(0xffAAB0B9);
  static const selectedBottomIcon = enabledButton;
}

class RegExpFields {
  static final emailRegExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  static final firstNameRegExp = RegExp(r'^[a-zA-Z]+$');
  static final passwordRegExp = RegExp(r'^[а-яА-Я]');
  static final addressRegExp = RegExp(r'[0-9a-fA-F]');
  static final addressBech32RegExp = RegExp(r'[0-9a-zA-Z]');
}

class Configs {
  static final configsNetwork = {
    NetworkName.workNetMainnet: ConfigNetwork(
      rpc: 'https://mainnet-gate.workquest.co/',
      wss: 'wss://mainnet-gate.workquest.co/tendermint-rpc/websocket',
      urlExplorer: 'https://explorer.workquest.co/address/',
      dataCoins: const [
        DataCoins(
          symbolToken: TokenSymbols.WQT,
          iconPath: 'assets/svg/wqt_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.WUSD,
          addressToken: '0x4d9F307F1fa63abC943b5db2CBa1c71D02d86AAa',
          iconPath: 'assets/svg/wusd_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.ETH,
          addressToken: '0x8E52341384F5286f4c76cE1072Aba887Be8E4EB9',
          iconPath: 'assets/svg/eth_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.BNB,
          addressToken: '0xD7ca5F803807b03D49606D4f8e66551170b1d689',
          iconPath: 'assets/svg/bsc_logo.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDT,
          addressToken: '0xD93d2cF0e0179112469188F61ceb948F2Dbe4824',
          iconPath: 'assets/svg/tusdt_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDC,
          addressToken: '0xc2E305033Ca1FFA1488E3e9C52769b1156336196',
          iconPath: 'assets/svg/usdc_icon.svg',
        ),
      ],
    ),

    ///Test-net
    NetworkName.workNetTestnet: ConfigNetwork(
      rpc: 'https://testnet-gate.workquest.co/',
      wss: 'wss://testnet-gate.workquest.co/tendermint-rpc/websocket',
      urlExplorer: 'https://testnet-explorer.workquest.co/address/',
      dataCoins: const [
        DataCoins(
          symbolToken: TokenSymbols.WQT,
          iconPath: 'assets/svg/wqt_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.WUSD,
          addressToken: '0xf95ef11d0af1f40995218bb2b67ef909bcf30078',
          iconPath: 'assets/svg/wusd_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.ETH,
          addressToken: '0xe550018bc9cf68fed303dfb5f225bb0e6b1e201f',
          iconPath: 'assets/svg/eth_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.BNB,
          addressToken: '0x0c874699373d34c3ccb322a10ed81aef005004a6',
          iconPath: 'assets/svg/bsc_logo.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDT,
          addressToken: '0x72603c4cf5a8474e7e85fa1b352bbda5539c3859',
          iconPath: 'assets/svg/tusdt_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDC,
          addressToken: '0xc2E305033Ca1FFA1488E3e9C52769b1156336196',
          iconPath: 'assets/svg/usdc_icon.svg',
        ),
      ],
    ),

    ///Dev-net
    // NetworkName.workNetTestnet: ConfigNetwork(
    //   rpc: 'https://dev-node-ams3.workquest.co/',
    //   wss: 'wss://wss-dev-node-ams3.workquest.co/tendermint-rpc/websocket',
    //   urlExplorer: 'https://dev-explorer.workquest.co/address/',
    //   dataCoins: const [
    //     DataCoins(
    //       symbolToken: TokenSymbols.WQT,
    //       iconPath: 'assets/svg/wqt_coin_icon.svg',
    //     ),
    //     DataCoins(
    //       symbolToken: TokenSymbols.WUSD,
    //       addressToken: '0x0ed13a696fa29151f3064077acb2a281e68df2aa',
    //       iconPath: 'assets/svg/wusd_coin_icon.svg',
    //     ),
    //     DataCoins(
    //       symbolToken: TokenSymbols.ETH,
    //       addressToken: '0xd9679c4bc6e1546cfcb9c70ac81a4cbf400e7d24',
    //       iconPath: 'assets/svg/eth_coin_icon.svg',
    //     ),
    //     DataCoins(
    //       symbolToken: TokenSymbols.BNB,
    //       addressToken: '0x0ed13a696fa29151f3064077acb2a281e68df2aa',
    //       iconPath: 'assets/svg/bsc_logo.svg',
    //     ),
    //     DataCoins(
    //       symbolToken: TokenSymbols.USDT,
    //       addressToken: '0xbd5bbed9677401e911044947cff9fa4979c29bd8',
    //       iconPath: 'assets/svg/tusdt_coin_icon.svg',
    //     ),
    //   ],
    // ),
    NetworkName.ethereumMainnet: ConfigNetwork(
      rpc: 'https://eth-mainnet.public.blastapi.io/',
      wss:
          'wss://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/eth/mainnet/ws',
      urlExplorer: 'https://etherscan.io/address/',
      dataCoins: const [
        DataCoins(
          symbolToken: TokenSymbols.ETH,
          iconPath: 'assets/svg/eth_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.WQT,
          addressToken: '0x06677Dc4fE12d3ba3C7CCfD0dF8Cd45e4D4095bF',
          iconPath: 'assets/svg/wqt_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDT,
          addressToken:
              '0xdAC17F958D2ee523a2206206994597C13D831ec7', // decimals 6
          iconPath: 'assets/svg/tusdt_coin_icon.svg',
        ),
      ],
    ),
    NetworkName.ethereumTestnet: ConfigNetwork(
      rpc: 'https://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/eth/rinkeby',
      wss:
          'wss://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/eth/rinkeby/ws',
      urlExplorer: 'https://rinkeby.etherscan.io/address/',
      dataCoins: const [
        DataCoins(
          symbolToken: TokenSymbols.ETH,
          iconPath: 'assets/svg/eth_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.WQT,
          addressToken: '0xe21D8B17CF2550DE4bC80779486BDC68Cb3a379E',
          iconPath: 'assets/svg/wqt_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDT,
          addressToken:
              '0xD92E713d051C37EbB2561803a3b5FBAbc4962431', // decimals 6
          iconPath: 'assets/svg/tusdt_coin_icon.svg',
        ),
      ],
    ),
    NetworkName.bscMainnet: ConfigNetwork(
      rpc: 'https://bscrpc.com/',
      wss:
          'wss://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/bsc/mainnet/ws',
      urlExplorer: 'https://bscscan.com/address/',
      dataCoins: const [
        DataCoins(
          symbolToken: TokenSymbols.BNB,
          iconPath: 'assets/svg/bsc_logo.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.WQT,
          addressToken: '0xe89508D74579A06A65B907c91F697CF4F8D9Fac7',
          iconPath: 'assets/svg/wqt_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDT,
          addressToken:
              '0x55d398326f99059ff775485246999027b3197955', // decimals 18
          iconPath: 'assets/svg/tusdt_coin_icon.svg',
        ),
      ],
    ),
    NetworkName.bscTestnet: ConfigNetwork(
      rpc: 'https://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/bsc/testnet',
      wss:
          'wss://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/bsc/testnet/ws',
      urlExplorer: 'https://testnet.bscscan.com/address/',
      dataCoins: const [
        DataCoins(
          symbolToken: TokenSymbols.BNB,
          iconPath: 'assets/svg/bsc_logo.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.WQT,
          addressToken: '0x8a62Ee790900Df4349B3c57a0FeBbf71f1f729Db',
          iconPath: 'assets/svg/wqt_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDT,
          addressToken:
              '0xC9bda0FA861Bd3F66c7d0Fd75A9A8344e6Caa94A', // decimals 18
          iconPath: 'assets/svg/tusdt_coin_icon.svg',
        ),
      ],
    ),
    NetworkName.polygonMainnet: ConfigNetwork(
      rpc: 'https://polygon-mainnet.public.blastapi.io/',
      wss:
          'wss://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/polygon/mainnet/ws',
      urlExplorer: 'https://polygonscan.com/address/',
      dataCoins: const [
        DataCoins(
          symbolToken: TokenSymbols.MATIC,
          iconPath: 'assets/svg/matic_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDT,
          addressToken:
              '0xc2132D05D31c914a87C6611C10748AEb04B58e8F', // decimals 6
          iconPath: 'assets/svg/tusdt_coin_icon.svg',
        ),
      ],
    ),
    NetworkName.polygonTestnet: ConfigNetwork(
      rpc:
          'https://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/polygon/mumbai',
      wss:
          'wss://speedy-nodes-nyc.moralis.io/${Keys.moralicKey}/polygon/mumbai/ws',
      urlExplorer: 'https://mumbai.polygonscan.com/address/',
      dataCoins: const [
        DataCoins(
          symbolToken: TokenSymbols.MATIC,
          iconPath: 'assets/svg/matic_coin_icon.svg',
        ),
        DataCoins(
          symbolToken: TokenSymbols.USDT,
          addressToken:
              '0x631E327EA88C37D4238B5c559A715332266e7Ec1', // decimals 6
          iconPath: 'assets/svg/tusdt_coin_icon.svg',
        ),
      ],
    ),
  };
}

class ConfigNetwork {
  final String rpc;
  final String wss;
  final String urlExplorer;
  final List<DataCoins> dataCoins;

  ConfigNetwork({
    required this.rpc,
    required this.wss,
    required this.urlExplorer,
    required this.dataCoins,
  });
}

class DataCoins {
  final TokenSymbols symbolToken;
  final String? addressToken;
  final String iconPath;

  const DataCoins({
    required this.symbolToken,
    required this.iconPath,
    this.addressToken,
  });
}

enum NetworkName {
  workNetMainnet,
  workNetTestnet,
  ethereumMainnet,
  ethereumTestnet,
  bscMainnet,
  bscTestnet,
  polygonMainnet,
  polygonTestnet
}

enum SwitchNetworkNames { WORKNET, ETH, BSC, POLYGON }

enum Network { mainnet, testnet }

enum TokenSymbols { WUSD, WQT, USDT, BNB, ETH, MATIC, USDC }
