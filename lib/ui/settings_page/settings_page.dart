import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/http/web_socket.dart';
import 'package:workquest_wallet_app/page_router.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/ui/login_page/login_page.dart';
import 'package:workquest_wallet_app/utils/storage.dart';
import 'package:workquest_wallet_app/widgets/gradient_icon.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';
import 'package:workquest_wallet_app/widgets/main_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../utils/snack_bar.dart';
import 'language_page.dart';

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
                  final result =
                      await PageRouter.pushNewRoute(context, const LanguagePage());
                  if (result != null && result) {
                    await Future.delayed(const Duration(milliseconds: 200));
                    SnackBarUtils.success(context, title: 'meta.languageChanged'.tr());
                    widget.update!.call();
                  }
                },
              ),
              const SizedBox(
                height: 20,
                width: double.infinity,
              ),
              // _SettingsItem(
              //   title: 'Network',
              //   subtitle: 'Mainnet',
              //   imagePath: Images.settingsNetworkIcon,
              //   onTab: () {
              //     // PageRouter.pushNewRoute(context, const NetworkPage());
              //     SnackBarUtils.example(context);
              //   },
              // ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    await PageRouter.pushNewRemoveRoute(context, const LoginPage());
                    await Storage.deleteAllFromSecureStorage();
                    WebSocket().closeWebSocket();
                    AccountRepository().clearData();
                  },
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
