import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/http/api.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';

part 'network_store.g.dart';

class NetworkStore = _NetworkStoreBase with _$NetworkStore;

abstract class _NetworkStoreBase extends IStore<bool> with Store {
  @observable
  Network? network;

  @action
  setNetwork(Network value) => network = value;

  @action
  changeNetwork(Network newNetwork) async {
    try {
      onLoading();
      final _wallet = AccountRepository().userWallet!;
      final signature =
          await AccountRepository().client!.getSignature(_wallet.privateKey!);
      await Api().login(signature, AccountRepository().userAddress,
          isMain: newNetwork == Network.mainnet);
      print('oldNetworkName: ${AccountRepository().networkName.value!}');
      final _newNetworkName =
          Web3Utils.getNetworkNameSwap(AccountRepository().networkName.value!);
      print('newNetworkName: $_newNetworkName');
      AccountRepository().notifierNetwork.value = newNetwork;
      AccountRepository().changeNetwork(_newNetworkName);
      network = newNetwork;
      onSuccess(true);
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }
}
