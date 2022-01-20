import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_radio.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0);

const _languages = [
  Locale('en', 'US'),
  Locale('ru', 'RU'),
];

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  Locale? _currentLanguage;

  @override
  Widget build(BuildContext context) {
    _currentLanguage = context.locale;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(
        title: 'settings'.tr(gender: 'language'),
      ),
      body: LayoutWithScroll(
        child: Padding(
          padding: _padding,
          child: Column(
            children: _languages.map((language) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      _currentLanguage = language;
                      if (_currentLanguage == const Locale('en', 'US')) {
                        await context.setLocale(const Locale('en', 'US'));
                      } else {
                        await context.setLocale(const Locale('ru', 'RU'));
                      }
                    },
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: SizedBox(
                        height: 36,
                        width: double.infinity,
                        child: Row(mainAxisSize: MainAxisSize.max, children: [
                          DefaultRadio(
                            status: _currentLanguage == language,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            _getTitleLanguage(language),
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColor.subtitleText,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            }).toList(),
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
