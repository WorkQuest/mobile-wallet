import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/constants.dart';

class ObserverListener<T extends IStore> extends StatefulWidget {
  final Function() onSuccess;
  final bool Function()? onFailure;
  final Widget child;
  final dynamic store;

  const ObserverListener({
    Key? key,
    required this.onSuccess,
    this.onFailure,
    required this.child,
    required this.store,
  }) : super(key: key);

  @override
  _ObserverListenerState createState() => _ObserverListenerState<T>();
}

class _ObserverListenerState<T extends IStore> extends State<ObserverListener> {
  late IStore _store;
  late List<ReactionDisposer> _disposers;

  @override
  void initState() {
    _store = widget.store;
    _disposers = [_successReaction, _failureReaction];
    super.initState();
  }

  ReactionDisposer get _successReaction {
    return reaction(
      (_) => _store.isSuccess,
      (bool isSuccess) {
        if (isSuccess) {
          widget.onSuccess();
        }
      },
    );
  }

  ReactionDisposer get _failureReaction {
    return reaction(
      (_) => _store.errorMessage,
      (String? errorMessage) {
        if (errorMessage != null) {
          if (widget.onFailure != null) if (widget.onFailure!()) return;
          final _words = errorMessage.split(' ');
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) {
              final title = 'meta.warning'.tr();
              return Platform.isIOS
                  ? CupertinoAlertDialog(
                      title: Text(title),
                      content: Builder(
                        builder: (_) => RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: '',
                              children: _words.map((word) {
                                return TextSpan(
                                    text: '$word ',
                                    style: TextStyle(
                                      color: isLink(word)
                                          ? AppColor.enabledButton
                                          : Colors.black,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = isLink(word)
                                          ? () async {
                                              if (await canLaunchUrl(
                                                  Uri.parse(word))) {
                                                launchUrl(Uri.parse(word));
                                              }
                                            }
                                          : null);
                              }).toList()),
                        ),
                      ),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text("OK"),
                          onPressed:
                              Navigator.of(context, rootNavigator: true).pop,
                        )
                      ],
                    )
                  : AlertDialog(
                      title: Text(title),
                      content: Builder(
                        builder: (_) => RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: '',
                              children: _words.map((word) {
                                return TextSpan(
                                    text: '$word ',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: isLink(word)
                                          ? AppColor.enabledButton
                                          : Colors.black,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = isLink(word)
                                          ? () async {
                                              // if (await canLaunchUrl(Uri.parse(word))) {
                                              //   launchUrl(Uri.parse(word));
                                              launch(word);
                                              // }
                                            }
                                          : null);
                              }).toList()),
                        ),
                      ),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text("OK"),
                          onPressed:
                              Navigator.of(context, rootNavigator: true).pop,
                        )
                      ],
                    );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    for (var d in _disposers) {
      d();
    }
    super.dispose();
  }

  bool isLink(String value) => value.contains('https');
}
