import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/http/api.dart';

import '../../../../utils/storage.dart';

part 'sign_up_confirm_store.g.dart';

class SignUpConfirmStore = SignUpConfirmStoreBase with _$SignUpConfirmStore;

abstract class SignUpConfirmStoreBase extends IStore<bool> with Store {

  @observable
  TextEditingController code = TextEditingController();

  SignUpConfirmStoreBase() {
    code.addListener(() {
      if (code.text.length == 6) {
        canConfirm = true;
      } else {
        canConfirm = false;
      }
    });
  }

  @observable
  bool canConfirm = false;

  @action
  confirm(String role) async {
    try {
      onLoading();
      await Api().confirmEmail(code: code.text, role: role);
      onSuccess(true);
      code.text = '';
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }

  @observable
  Timer? timer;

  @observable
  int secondsCodeAgain = 60;

  Future<void> initTime(String email) async {
    final time = await Storage.read(StorageKeys.timeTimer.toString());
    if ((time ?? "0") != "0") {
      stopTimer();
      startTimer(email);
    }
  }

  @action
  startTimer(String email) async {
    try {
      await Api().resendCodeEmail(email: email);
      final timerTime = await Storage.read(StorageKeys.timeTimer.toString());
      if ((timerTime ?? "0") != "0") {
        secondsCodeAgain = int.parse(timerTime!);
      } else {
        await Storage.write(StorageKeys.timeTimer.toString(), secondsCodeAgain.toString());
      }
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (secondsCodeAgain == 0) {
          timer.cancel();
          secondsCodeAgain = 60;
        } else {
          secondsCodeAgain--;
          Storage.write(StorageKeys.timeTimer.toString(), secondsCodeAgain.toString());
        }
      });
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  stopTimer() {
    if (timer != null) {
      timer!.cancel();
    }
    secondsCodeAgain = 60;
  }
}
