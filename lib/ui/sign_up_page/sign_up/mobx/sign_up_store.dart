import 'dart:convert';
import 'dart:math';

import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/http/api.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
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
  String? selectedFirstWord;

  @observable
  String? selectedSecondWord;

  @observable
  ObservableList<String>? setOfWords;

  @action
  setIsSaved(bool value) => isSaved = value;

  @computed
  bool get statusGenerateButton => selectedFirstWord == firstWord && selectedSecondWord == secondWord;

  @action
  selectFirstWord(String? value) => selectedFirstWord = value;

  @action
  selectSecondWord(String? value) => selectedSecondWord = value;

  @action
  generateMnemonic() {
    mnemonic = AddressService.generateMnemonic();
    final list = mnemonic!.split(' ').toList();
    firstWord = list[2];
    secondWord = list[6];
  }

  @action
  splitPhraseIntoWords() {
    setOfWords = ObservableList.of([]);

    final _random = Random();

    final list = mnemonic!.split(' ').toList();

    for (var i = list.length - 1; i > 6; i--) {
      var n = _random.nextInt(i + 1);
      if (setOfWords!.length == 6) {
        break;
      }
      setOfWords!.add(list[n]);
    }
    if (!setOfWords!.contains(firstWord)) {
      setOfWords!.add(firstWord!);
    } else {
      setOfWords!.add(list.last);
    }
    if (!setOfWords!.contains(secondWord)) {
      setOfWords!.add(secondWord!);
    } else {
      setOfWords!.add(list.last);
    }
    setOfWords!.shuffle();
  }

  @action
  openWallet() async {
    onLoading();
    try {
      Wallet wallet = await Wallet.derive(mnemonic!);
      final result = await Api().registerWallet(wallet.publicKey!, wallet.address!);
      if (!result) {
        onError("Server error");
        return;
      }
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
