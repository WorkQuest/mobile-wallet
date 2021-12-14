import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/ui/main_page/main_page.dart';
import 'package:workquest_wallet_app/utils/modal_bottom_sheet.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';

import '../../page_router.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);
const _errorColor = Colors.red;

class SignUpChoosePage extends StatefulWidget {
  const SignUpChoosePage({Key? key}) : super(key: key);

  @override
  _SignUpChoosePageState createState() => _SignUpChoosePageState();
}

class _SignUpChoosePageState extends State<SignUpChoosePage> {
  int? indexFirstWord;
  int? indexSecondWord;

  List<_WordsItem> words = [
    _WordsItem(true, "Lorem"),
    _WordsItem(true, "adipiscing"),
    _WordsItem(false, "sit"),
    _WordsItem(false, "aliquam"),
    _WordsItem(false, "dolor"),
    _WordsItem(false, "purus"),
    _WordsItem(false, "consectetur"),
  ];

  bool get _statusButton => indexFirstWord != null && indexSecondWord != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const Text(
                'Choose the 12th and 16th words of your mnemonic',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                '12th word',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _WordsWidget(
                index: indexFirstWord,
                words: words,
                onTab: _pressedOnWord,
                isFirst: true,
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                '16th word',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _WordsWidget(
                index: indexSecondWord,
                words: words,
                onTab: _pressedOnWord,
                isFirst: false,
              ),
              Expanded(child: Container()),
              Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 10.0),
                width: double.infinity,
                child: DefaultButton(
                  title: 'Open wallet',
                  onPressed: _statusButton ? _pushMainPage : null,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _pushMainPage() {
    PageRouter.pushNewReplacementRoute(context, const MainPage());
  }

  void _pressedOnWord(int? indexWord, _WordsItem word, bool isFirstWord) async {
    if (indexWord == null) {
      setState(() {
        if (isFirstWord) {
          indexFirstWord = words.indexOf(word);
        } else {
          indexSecondWord = words.indexOf(word);
        }
      });
      if (!word.status) {
        await _openModalBottomSheet();
        setState(() {
          indexFirstWord = null;
          indexSecondWord = null;
        });
        return;
      }
    }
    _showModal();
  }

  void _showModal() async {
    if (indexFirstWord != null && indexSecondWord != null) {
      if (!words[indexFirstWord!].status || !words[indexSecondWord!].status) {
        await _openModalBottomSheet();
        setState(() {
          indexFirstWord = null;
          indexSecondWord = null;
        });
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
            children: const [
              Text(
                'Error',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 11,
              ),
              Text(
                'You’ve chosen wrong words. Try again ',
                style: TextStyle(
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
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
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
    );
  }
}

class _WordsWidget extends StatelessWidget {
  final Function(int?, _WordsItem, bool) onTab;
  final List<_WordsItem> words;
  final bool isFirst;
  final int? index;

  const _WordsWidget({
    Key? key,
    required this.onTab,
    required this.words,
    required this.isFirst,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: words.map((word) {
        if (index != null && words[index!] == word) {
          return Container(
            margin: const EdgeInsets.only(right: 10.0, bottom: 10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(
                color: AppColor.disabledButton,
              ),
              color: word.status ? AppColor.enabledButton : _errorColor,
            ),
            child: Text(
              word.title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          );
        }
        return GestureDetector(
          onTap: () => onTab(index, word, isFirst),
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
              word.title,
              style: const TextStyle(fontSize: 16, color: Color(0xff4C5767)),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _WordsItem {
  bool status;
  String title;

  _WordsItem(this.status, this.title);
}
