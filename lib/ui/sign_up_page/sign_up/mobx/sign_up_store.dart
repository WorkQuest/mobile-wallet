import 'dart:convert';

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
    mnemonic = AddressService().generateMnemonic();
    final list = mnemonic!.split(' ').toList();
    firstWord = list[2];
    secondWord = list[6];
  }

  @action
  splitPhraseIntoWords() {
    setOfWords = ObservableList.of([]);

    // final _random = Random();

    final list = mnemonic!.split(' ').toList();

    setOfWords!.add(list[0]);
    setOfWords!.add(list[10]);
    setOfWords!.add(list[2]);
    setOfWords!.add(list[8]);
    setOfWords!.add(list[6]);
    setOfWords!.add(list[4]);
    setOfWords!.add(list[11]);

    // for (var i = list.length - 1; i > 4; i--) {
    //   var n = _random.nextInt(i + 1);
    //   if (setOfWords!.length == 7) {
    //     break;
    //   }
    //   while (setOfWords!.contains(list[n])) {
    //     n = _random.nextInt(i + 1);
    //   }
    //   setOfWords!.add(list[n]);
    // }
    // if (!setOfWords!.contains(firstWord)) {
    //   setOfWords!.removeLast();
    //   setOfWords!.insert(0, firstWord!);
    // }
    // if (!setOfWords!.contains(secondWord)) {
    //   setOfWords!.removeLast();
    //   setOfWords!.insert(0, secondWord!);
    // }
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
      await Storage.write(StorageKeys.wallets.toString(), jsonEncode([wallet.toJson()]));
      await Storage.write(StorageKeys.address.toString(), wallet.address!);
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
