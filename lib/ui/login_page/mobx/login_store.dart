import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/session_repository.dart';
import 'package:workquest_wallet_app/utils/storage.dart';
import 'package:workquest_wallet_app/utils/wallet.dart';

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
      Wallet? wallet = await Wallet.derive(mnemonic);
      if (GetIt.I.get<SessionRepository>().networkName.value == null) {
        final _networkName =
            GetIt.I.get<SessionRepository>().notifierNetwork.value ==
                    Network.mainnet
                ? NetworkName.workNetMainnet
                : NetworkName.workNetTestnet;
        GetIt.I.get<SessionRepository>().setNetwork(_networkName);
      }
      GetIt.I.get<SessionRepository>().setWallet(wallet);
      GetIt.I.get<SessionRepository>().connectClient();
      await _saveToStorage(wallet);
      onSuccess(true);
    } on FormatException catch (e) {
      GetIt.I.get<SessionRepository>().clearData();
      onError(e.message);
    } catch (e) {
      GetIt.I.get<SessionRepository>().clearData();
      onError(e.toString());
    }
  }

  Future _saveToStorage(Wallet wallet) async {
    await Storage.write(StorageKeys.wallet.name, jsonEncode(wallet.toJson()));
  }
}
