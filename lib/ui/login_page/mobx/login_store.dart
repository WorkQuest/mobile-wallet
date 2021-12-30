import 'dart:convert';

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
      Wallet? wallet = await Wallet.derive(mnemonic);
      final signature = await AccountRepository().client!.getSignature(wallet.privateKey!);
      final result = await Api().login(signature, wallet.address!);
      await Storage.write(Storage.refreshKey, result!.data['result']['refresh']);
      await Storage.write(Storage.wallets, jsonEncode([wallet.toJson()]));
      await Storage.write(Storage.activeAddress, wallet.address!);
      AccountRepository().userAddress = wallet.address;
      AccountRepository().addWallet(wallet);
      onSuccess(true);
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }
}
