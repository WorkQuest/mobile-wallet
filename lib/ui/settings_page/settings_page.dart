import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/page_router.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/ui/login_page/login_page.dart';
import 'package:workquest_wallet_app/ui/settings_page/language_page.dart';
import 'package:workquest_wallet_app/ui/settings_page/network_page.dart';
import 'package:workquest_wallet_app/utils/storage.dart';
import 'package:workquest_wallet_app/widgets/alert_success.dart';
import 'package:workquest_wallet_app/widgets/gradient_icon.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';
import 'package:workquest_wallet_app/widgets/main_app_bar.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MainAppBar(
        title: 'Settings',
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
                title: 'Language',
                subtitle: 'English',
                imagePath: Images.settingsLanguageIcon,
                onTab: () {
                  PageRouter.pushNewRoute(context, const LanguagePage());
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
              //     PageRouter.pushNewRoute(context, const NetworkPage());
              //   },
              // ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: CupertinoButton(
                  onPressed: () async {
                    await Storage.deleteAllFromSecureStorage();
                    AccountRepository().clearData();
                    PageRouter.pushNewRemoveRoute(
                        context, const LoginPage());
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
                    child: const Text(
                      'Log out',
                      style: TextStyle(fontSize: 16, color: Colors.red),
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
