// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NetworkStore on _NetworkStoreBase, Store {
  late final _$networkAtom =
      Atom(name: '_NetworkStoreBase.network', context: context);

  @override
  Network? get network {
    _$networkAtom.reportRead();
    return super.network;
  }

  @override
  set network(Network? value) {
    _$networkAtom.reportWrite(value, super.network, () {
      super.network = value;
    });
  }

  late final _$changeNetworkAsyncAction =
      AsyncAction('_NetworkStoreBase.changeNetwork', context: context);

  @override
  Future changeNetwork(Network newNetwork) {
    return _$changeNetworkAsyncAction
        .run(() => super.changeNetwork(newNetwork));
  }

  late final _$_NetworkStoreBaseActionController =
      ActionController(name: '_NetworkStoreBase', context: context);

  @override
  dynamic setNetwork(Network value) {
    final _$actionInfo = _$_NetworkStoreBaseActionController.startAction(
        name: '_NetworkStoreBase.setNetwork');
    try {
      return super.setNetwork(value);
    } finally {
      _$_NetworkStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
network: ${network}
    ''';
  }
}
