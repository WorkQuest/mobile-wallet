
import 'package:flutter/material.dart';

class Images {
  static const _imagePath = "assets/images";
  static const _svgPath = "assets/svg";

  static const loginImage = "$_imagePath/background_login_page.png";
  static const languageSettingsImage = "$_imagePath/language_settings_image.png";
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
  static const removePinIcon = "$_svgPath/remove_pin_icon.svg";

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
  static final passwordRegExp = RegExp(r'^[??-????-??]');
  static final addressRegExp = RegExp(r'[0-9a-fA-F]');
}

class AddressCoins {
  static const wqt = '0x917dc1a9e858deb0a5bdcb44c7601f655f728dfe';
  static const wEth = '0x75fc17d0c358f19528d5c24f29b37fa2aa725b1e';
  static const wBnb = '0x9c9fe9a77a3b0ed1d3584afadd5873843baf0e12';
}
