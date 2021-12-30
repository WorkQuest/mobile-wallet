import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/http/api.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/utils/storage.dart';

part 'splash_store.g.dart';

class SplashStore = SplashStoreBase with _$SplashStore;

abstract class SplashStoreBase extends IStore<bool> with Store {
  @observable
  bool? isLoginPage;

  @action
  sign() async {
    onLoading();
    try {
      final refreshToken = await Storage.read(Storage.refreshKey);
      if (refreshToken == null || AccountRepository().userAddresses!.isEmpty) {
        isLoginPage = true;
        onSuccess(true);
        return;
      }
      final refresh = await Api().refreshToken(refreshToken);
      await Storage.write(Storage.refreshKey, refresh);
      isLoginPage = false;
      onSuccess(true);
    } catch (e) {
      onError(e.toString());
    }
  }
}
