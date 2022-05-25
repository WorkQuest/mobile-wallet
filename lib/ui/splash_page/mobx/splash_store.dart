import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
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
      final refreshToken = await Storage.read(StorageKeys.refreshToken.toString());
      if (refreshToken == null || (AccountRepository().userWallet == null)) {
        isLoginPage = true;
        onSuccess(true);
        return;
      }
      // final refresh = await Api().refreshToken(refreshToken);
      // await Storage.write(StorageKeys.refreshToken.toString(), refresh!);
      isLoginPage = false;
      onSuccess(true);
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e, trace) {
      print('$e\n$trace');
      onError(e.toString());
    }
  }
}
