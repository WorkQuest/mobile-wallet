import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/http/web_socket.dart';
import 'package:workquest_wallet_app/page_router.dart';
import 'package:workquest_wallet_app/repository/session_repository.dart';
import 'package:workquest_wallet_app/ui/login_page/login_page.dart';
import 'package:workquest_wallet_app/ui/transfer_page/mobx/transfer_store.dart';
import 'package:workquest_wallet_app/utils/snack_bar.dart';
import 'package:workquest_wallet_app/widgets/gradient_icon.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';
import 'package:workquest_wallet_app/widgets/main_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';

import 'language_page.dart';
import 'network_page/network_page.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

class SettingsPage extends StatefulWidget {
  final Function? update;

  const SettingsPage({Key? key, required this.update}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(
        title: 'settings.settings'.tr(),
      ),
      body: LayoutWithScroll(
        child: Padding(
          padding: _padding,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
                width: double.infinity,
              ),
              _SettingsItem(
                title: 'settings.language'.tr(),
                subtitle: _getTitleLanguage(context.locale),
                imagePath: Images.settingsLanguageIcon,
                onTab: () async {
                  final result = await PageRouter.pushNewRoute(
                      context, const LanguagePage());
                  if (result != null && result) {
                    await Future.delayed(const Duration(milliseconds: 200));
                    SnackBarUtils.success(context,
                        title: 'meta.languageChanged'.tr());
                    widget.update!.call();
                  }
                },
              ),
              const SizedBox(
                height: 20,
                width: double.infinity,
              ),
              _SettingsItem(
                title: 'wallet.network'.tr(),
                subtitle: _getCurrentNetworkName(),
                imagePath: Images.settingsNetworkIcon,
                onTab: () async {
                  await PageRouter.pushNewRoute(context, const NetworkPage());
                  setState(() {});
                },
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _showLogOutDialog,
                  child: Container(
                    height: 43,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffDF3333).withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Text(
                      'meta'.tr(gender: 'log_out'),
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showLogOutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('meta.log_out'.tr()),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('meta.log_out_dialog'.tr()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('meta'.tr(gender: 'log_out_cancel'),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('meta'.tr(gender: 'log_out_confirm'),),
              onPressed: () {
                _onPressedLogout();
              },
            ),
          ],
        );
      },
    );
  }
  _onPressedLogout() async {
    await PageRouter.pushNewRemoveRoute(context, const LoginPage());
    WebSocket().closeWebSocket();
    GetIt.I.get<TransferStore>().setCoin(null);
    GetIt.I.get<SessionRepository>().clearData();
  }

  String _getCurrentNetworkName() {
    final _name = (GetIt.I.get<SessionRepository>().notifierNetwork.value).name;
    return '${_name.substring(0, 1).toUpperCase()}${_name.substring(1)}';
  }

  String _getTitleLanguage(Locale locale) {
    if (locale == const Locale('en', 'US')) {
      return "English";
    } else if (locale == const Locale('ru', 'RU')) {
      return "Русский";
    } else {
      return "Arabian";
    }
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final Function() onTab;

  const _SettingsItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTab,
      pressedOpacity: 0.4,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: AppColor.disabledButton,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GradientIcon(icon: SvgPicture.asset(imagePath), size: 28.125),
            const SizedBox(
              width: 21.5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColor.unselectedBottomIcon,
                  ),
                ),
              ],
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Transform.rotate(
                angle: -pi / 2.0,
                child: SvgPicture.asset(
                  Images.chooseCoinIcon,
                  width: 5,
                  height: 8,
                  color: AppColor.disabledText,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
