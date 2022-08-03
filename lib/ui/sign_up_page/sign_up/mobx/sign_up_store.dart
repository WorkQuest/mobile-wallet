import 'dart:convert';
import 'dart:math';

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/session_repository.dart';
import 'package:workquest_wallet_app/service/address_service.dart';
import 'package:workquest_wallet_app/utils/storage.dart';
import 'package:workquest_wallet_app/utils/wallet.dart';

part 'sign_up_store.g.dart';

class SignUpStore = SignUpStoreBase with _$SignUpStore;

abstract class SignUpStoreBase extends IStore<bool> with Store {
  @observable
  String? mnemonic;

  @observable
  bool isSaved = false;

  @observable
  String? firstWord;

  @observable
  String? secondWord;

  @observable
  int? indexFirstWord;

  @observable
  int? indexSecondWord;

  @observable
  String? selectedFirstWord;

  @observable
  String? selectedSecondWord;

  @observable
  ObservableList<String>? setOfWords;

  @action
  setMnemonic(String value) {
    mnemonic = value;
  }

  @action
  setIsSaved(bool value) => isSaved = value;

  @computed
  bool get statusGenerateButton =>
      selectedFirstWord == firstWord && selectedSecondWord == secondWord;

  @action
  selectFirstWord(String? value) => selectedFirstWord = value;

  @action
  selectSecondWord(String? value) => selectedSecondWord = value;

  @action
  generateMnemonic() {
    mnemonic = AddressService.generateMnemonic();
  }

  @action
  splitPhraseIntoWords() {
    setOfWords = ObservableList.of([]);
    final list = mnemonic!.split(' ').toList();
    setOfWords!.addAll(_listRandom(list));

    setOfWords!.shuffle();
  }

  List<String> _listRandom(List<String> list) {
    Random _random = Random();

    indexFirstWord = _random.nextInt(5) + 1;
    indexSecondWord = _random.nextInt(5) + 6;
    while (indexSecondWord == indexFirstWord) {
      indexSecondWord = _random.nextInt(11) + 1;
    }
    firstWord = list[indexFirstWord! - 1];
    secondWord = list[indexSecondWord! - 1];

    list.shuffle(_random);
    List<String> result = [];
    int i = 0;
    while (result.length < 5) {
      if (list[i] != firstWord && list[i] != secondWord) {
        result.add(list[i]);
      }
      i++;
    }
    result.add(firstWord!);
    result.add(secondWord!);
    result.shuffle(_random);
    return result;
  }

  @action
  openWallet() async {
    onLoading();
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      Wallet? wallet = await Wallet.derive(mnemonic!);
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
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }

  Future _saveToStorage(Wallet wallet) async {
    await Storage.write(StorageKeys.wallet.name, jsonEncode(wallet.toJson()));
  }
}
