import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/http/api.dart';
import 'package:workquest_wallet_app/utils/storage.dart';

part 'sign_up_profile_store.g.dart';

class SignUpProfileStore = SignUpProfileStoreBase with _$SignUpProfileStore;

abstract class SignUpProfileStoreBase extends IStore<bool> with Store {
  @observable
  TextEditingController email = TextEditingController();

  @observable
  TextEditingController firstName = TextEditingController();

  @observable
  TextEditingController lastName = TextEditingController();

  @observable
  TextEditingController password = TextEditingController();

  @observable
  TextEditingController passwordConfirm = TextEditingController();

  @action
  register() async {
    try {
      onLoading();
      final result = await Api().register(
        firstName.text,
        lastName.text,
        email.text,
        password.text,
      );
      await Storage.write(StorageKeys.refreshToken.toString(), result!.data['result']['refresh']);
      await Storage.write(StorageKeys.accessToken.toString(), result.data['result']['access']);
      onSuccess(true);
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }
}
