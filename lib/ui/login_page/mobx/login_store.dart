import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/utils/storage.dart';
import 'package:workquest_wallet_app/utils/wallet.dart';
import 'package:workquest_wallet_app/http/api.dart';

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase extends IStore<bool> with Store {

  @observable
  String mnemonic = '';

  @computed
  bool get statusButton => mnemonic.isNotEmpty;

  @action
  setMnemonic(String value) => mnemonic = value;

  @action
  login(String mnemonic) async {
    try {
      onLoading();
      await Future.delayed(const Duration(milliseconds: 500));
      AccountRepository().connectClient();
      Wallet? wallet = await Wallet.derive(mnemonic);
      final signature = await AccountRepository().client!.getSignature(wallet.privateKey!);
      final result = await Api().login(signature, wallet.address!);

      await saveToStorage(result!, wallet);
      AccountRepository().clearData();
      AccountRepository().userAddress = wallet.address;
      AccountRepository().addWallet(wallet);
      if (result.data['result']['userStatus'] == 0) {
        onSuccess(false);
        return;
      }
      onSuccess(true);
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      // print('cry$e$trace');
      onError(e.toString());
    }
  }

  Future saveToStorage(Response result, Wallet wallet) async {
    await Storage.write(StorageKeys.refreshToken.toString(), result.data['result']['refresh']);
    await Storage.write(StorageKeys.accessToken.toString(), result.data['result']['access']);
    await Storage.write(StorageKeys.wallets.toString(), jsonEncode([wallet.toJson()]));
    await Storage.write(StorageKeys.address.toString(), wallet.address!);
  }
}
