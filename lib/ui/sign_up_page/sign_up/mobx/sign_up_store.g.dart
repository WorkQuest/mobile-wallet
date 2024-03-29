// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SignUpStore on SignUpStoreBase, Store {
  Computed<bool>? _$statusGenerateButtonComputed;

  @override
  bool get statusGenerateButton => (_$statusGenerateButtonComputed ??=
          Computed<bool>(() => super.statusGenerateButton,
              name: 'SignUpStoreBase.statusGenerateButton'))
      .value;

  late final _$mnemonicAtom =
      Atom(name: 'SignUpStoreBase.mnemonic', context: context);

  @override
  String? get mnemonic {
    _$mnemonicAtom.reportRead();
    return super.mnemonic;
  }

  @override
  set mnemonic(String? value) {
    _$mnemonicAtom.reportWrite(value, super.mnemonic, () {
      super.mnemonic = value;
    });
  }

  late final _$isSavedAtom =
      Atom(name: 'SignUpStoreBase.isSaved', context: context);

  @override
  bool get isSaved {
    _$isSavedAtom.reportRead();
    return super.isSaved;
  }

  @override
  set isSaved(bool value) {
    _$isSavedAtom.reportWrite(value, super.isSaved, () {
      super.isSaved = value;
    });
  }

  late final _$firstWordAtom =
      Atom(name: 'SignUpStoreBase.firstWord', context: context);

  @override
  String? get firstWord {
    _$firstWordAtom.reportRead();
    return super.firstWord;
  }

  @override
  set firstWord(String? value) {
    _$firstWordAtom.reportWrite(value, super.firstWord, () {
      super.firstWord = value;
    });
  }

  late final _$secondWordAtom =
      Atom(name: 'SignUpStoreBase.secondWord', context: context);

  @override
  String? get secondWord {
    _$secondWordAtom.reportRead();
    return super.secondWord;
  }

  @override
  set secondWord(String? value) {
    _$secondWordAtom.reportWrite(value, super.secondWord, () {
      super.secondWord = value;
    });
  }

  late final _$indexFirstWordAtom =
      Atom(name: 'SignUpStoreBase.indexFirstWord', context: context);

  @override
  int? get indexFirstWord {
    _$indexFirstWordAtom.reportRead();
    return super.indexFirstWord;
  }

  @override
  set indexFirstWord(int? value) {
    _$indexFirstWordAtom.reportWrite(value, super.indexFirstWord, () {
      super.indexFirstWord = value;
    });
  }

  late final _$indexSecondWordAtom =
      Atom(name: 'SignUpStoreBase.indexSecondWord', context: context);

  @override
  int? get indexSecondWord {
    _$indexSecondWordAtom.reportRead();
    return super.indexSecondWord;
  }

  @override
  set indexSecondWord(int? value) {
    _$indexSecondWordAtom.reportWrite(value, super.indexSecondWord, () {
      super.indexSecondWord = value;
    });
  }

  late final _$selectedFirstWordAtom =
      Atom(name: 'SignUpStoreBase.selectedFirstWord', context: context);

  @override
  String? get selectedFirstWord {
    _$selectedFirstWordAtom.reportRead();
    return super.selectedFirstWord;
  }

  @override
  set selectedFirstWord(String? value) {
    _$selectedFirstWordAtom.reportWrite(value, super.selectedFirstWord, () {
      super.selectedFirstWord = value;
    });
  }

  late final _$selectedSecondWordAtom =
      Atom(name: 'SignUpStoreBase.selectedSecondWord', context: context);

  @override
  String? get selectedSecondWord {
    _$selectedSecondWordAtom.reportRead();
    return super.selectedSecondWord;
  }

  @override
  set selectedSecondWord(String? value) {
    _$selectedSecondWordAtom.reportWrite(value, super.selectedSecondWord, () {
      super.selectedSecondWord = value;
    });
  }

  late final _$setOfWordsAtom =
      Atom(name: 'SignUpStoreBase.setOfWords', context: context);

  @override
  ObservableList<String>? get setOfWords {
    _$setOfWordsAtom.reportRead();
    return super.setOfWords;
  }

  @override
  set setOfWords(ObservableList<String>? value) {
    _$setOfWordsAtom.reportWrite(value, super.setOfWords, () {
      super.setOfWords = value;
    });
  }

  late final _$openWalletAsyncAction =
      AsyncAction('SignUpStoreBase.openWallet', context: context);

  @override
  Future openWallet() {
    return _$openWalletAsyncAction.run(() => super.openWallet());
  }

  late final _$SignUpStoreBaseActionController =
      ActionController(name: 'SignUpStoreBase', context: context);

  @override
  dynamic setMnemonic(String value) {
    final _$actionInfo = _$SignUpStoreBaseActionController.startAction(
        name: 'SignUpStoreBase.setMnemonic');
    try {
      return super.setMnemonic(value);
    } finally {
      _$SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsSaved(bool value) {
    final _$actionInfo = _$SignUpStoreBaseActionController.startAction(
        name: 'SignUpStoreBase.setIsSaved');
    try {
      return super.setIsSaved(value);
    } finally {
      _$SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic selectFirstWord(String? value) {
    final _$actionInfo = _$SignUpStoreBaseActionController.startAction(
        name: 'SignUpStoreBase.selectFirstWord');
    try {
      return super.selectFirstWord(value);
    } finally {
      _$SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic selectSecondWord(String? value) {
    final _$actionInfo = _$SignUpStoreBaseActionController.startAction(
        name: 'SignUpStoreBase.selectSecondWord');
    try {
      return super.selectSecondWord(value);
    } finally {
      _$SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic generateMnemonic() {
    final _$actionInfo = _$SignUpStoreBaseActionController.startAction(
        name: 'SignUpStoreBase.generateMnemonic');
    try {
      return super.generateMnemonic();
    } finally {
      _$SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic splitPhraseIntoWords() {
    final _$actionInfo = _$SignUpStoreBaseActionController.startAction(
        name: 'SignUpStoreBase.splitPhraseIntoWords');
    try {
      return super.splitPhraseIntoWords();
    } finally {
      _$SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
mnemonic: ${mnemonic},
isSaved: ${isSaved},
firstWord: ${firstWord},
secondWord: ${secondWord},
indexFirstWord: ${indexFirstWord},
indexSecondWord: ${indexSecondWord},
selectedFirstWord: ${selectedFirstWord},
selectedSecondWord: ${selectedSecondWord},
setOfWords: ${setOfWords},
statusGenerateButton: ${statusGenerateButton}
    ''';
  }
}
