import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';

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
          showCupertinoDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) {
              final title = 'meta.error'.tr();
              return Platform.isIOS
                  ? CupertinoAlertDialog(
                      title: Text(title),
                      content: Text(errorMessage),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text("OK"),
                          onPressed: Navigator.of(context, rootNavigator: true).pop,
                        )
                      ],
                    )
                  : AlertDialog(
                      title: Text(title),
                      content: Text(errorMessage),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text("OK"),
                          onPressed: Navigator.of(context, rootNavigator: true).pop,
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
}
