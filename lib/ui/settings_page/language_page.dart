import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_radio.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0);

const _languages = [
  'English',
  // 'Mandarin Chinese',
  // 'Hindi',
  // 'Spanish',
  // 'French',
  // 'Standart Arabic',
  // 'Bengali',
  'Russian',
  // 'Portuguese',
  // 'Indonesian',
];

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {

  String? _currentLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const DefaultAppBar(
        title: 'Language',
      ),
      body: LayoutWithScroll(
        child: Padding(
          padding: _padding,
          child: Column(
            children: _languages.map((language) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentLanguage = language;
                      });
                    },
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: SizedBox(
                        height: 36,
                        width: double.infinity,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                            children: [
                          DefaultRadio(
                            status: _currentLanguage == language,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            language,
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
}
