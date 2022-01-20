import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/http/api.dart';

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
  confirm() async {
    try {
      onLoading();
      await Api().confirmEmail(code.text);
      onSuccess(true);
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }
}
