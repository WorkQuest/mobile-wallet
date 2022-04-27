import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/src/provider.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/ui/login_page/login_page.dart';
import 'package:workquest_wallet_app/ui/sign_up_page/sign_up/mobx/sign_up_store.dart';
import 'package:workquest_wallet_app/utils/alert_dialog.dart';
import 'package:workquest_wallet_app/utils/modal_bottom_sheet.dart';
import 'package:workquest_wallet_app/widgets/animation/login_button.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';
import 'package:workquest_wallet_app/widgets/observer_consumer.dart';

import '../../../page_router.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);
const _errorColor = Colors.red;

class SignUpChoosePage extends StatefulWidget {
  const SignUpChoosePage({Key? key}) : super(key: key);

  @override
  _SignUpChoosePageState createState() => _SignUpChoosePageState();
}

class _SignUpChoosePageState extends State<SignUpChoosePage> {
  @override
  void initState() {
    super.initState();
    final store = context.read<SignUpStore>();
    store.splitPhraseIntoWords();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<SignUpStore>();
    return Observer(
      builder: (_) => Scaffold(
        appBar: const DefaultAppBar(),
        body: LayoutWithScroll(
          child: Container(
            color: Colors.white,
            padding: _padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Choose the ${store.indexFirstWord}th and ${store.indexSecondWord}th words of your mnemonic',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  '${store.indexFirstWord}th word',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _WordsWidget(
                  words: store.setOfWords!.toList(),
                  onTab: _pressedOnWord,
                  isFirst: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  '${store.indexSecondWord}th word',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _WordsWidget(
                  words: store.setOfWords!.toList(),
                  onTab: _pressedOnWord,
                  isFirst: false,
                ),
                Expanded(child: Container()),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: double.infinity,
                      ),
                      ObserverListener(
                        store: store,
                        onFailure: () {
                          return false;
                        },
                        onSuccess: () async {
                          await AlertDialogUtils.showSuccessDialog(context);
                          PageRouter.pushNewRemoveRoute(context, const LoginPage());
                        },
                        child: Observer(
                          builder: (_) => LoginButton(
                            title: 'signUp.openWallet'.tr(),
                            onTap: store.statusGenerateButton
                                ? () {
                                    store.openWallet();
                                  }
                                : null,
                            enabled: store.isLoading,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pressedOnWord(String word, bool isFirstWord) async {
    final store = context.read<SignUpStore>();
    if (isFirstWord) {
      if (store.selectedFirstWord == null) {
        store.selectFirstWord(word);
      }
      if (store.selectedFirstWord != store.firstWord) {
        await _openModalBottomSheet();
        store.selectFirstWord(null);
        store.selectSecondWord(null);
      }
    } else {
      if (store.selectedSecondWord == null) {
        store.selectSecondWord(word);
      }
      if (store.selectedSecondWord != store.secondWord) {
        await _openModalBottomSheet();
        store.selectFirstWord(null);
        store.selectSecondWord(null);
      }
    }
  }

  Future<void> _openModalBottomSheet() async {
    await ModalBottomSheet.openModalBottomSheet(
        context,
        Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'meta.error'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 11,
                ),
                Text(
                  'signUp.chosenWrongWords'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
              child: SizedBox(
                width: double.infinity,
                child: DefaultButton(
                  title: 'Ok',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            )
          ],
        ),
        height: 225);
  }
}

class _WordsWidget extends StatelessWidget {
  final Function(String, bool) onTab;
  final List<String> words;
  final bool isFirst;

  const _WordsWidget({
    Key? key,
    required this.onTab,
    required this.words,
    required this.isFirst,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = context.read<SignUpStore>();

    return Observer(
      builder: (_) => Wrap(
        children: words.map((word) {
          bool selectedWord;
          bool color;
          if (isFirst) {
            selectedWord = word == store.selectedFirstWord;
            color = store.selectedFirstWord == store.firstWord;
          } else {
            selectedWord = word == store.selectedSecondWord;
            color = store.selectedSecondWord == store.secondWord;
          }
          if (selectedWord) {
            return Container(
              margin: const EdgeInsets.only(right: 10.0, bottom: 10.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: AppColor.disabledButton,
                ),
                color: color ? AppColor.enabledButton : _errorColor,
              ),
              child: Text(
                word,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            );
          }
          return GestureDetector(
            onTap: () => onTab(word, isFirst),
            child: Container(
              margin: const EdgeInsets.only(right: 10.0, bottom: 10.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: AppColor.disabledButton,
                ),
              ),
              child: Text(
                word,
                style: const TextStyle(fontSize: 16, color: Color(0xff4C5767)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
