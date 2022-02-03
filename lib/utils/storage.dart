import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:workquest_wallet_app/utils/wallet.dart';

class Storage {
  static FlutterSecureStorage get _secureStorage => const FlutterSecureStorage();

  static Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  static Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  static Future<void> delete(String key) async {
    return await _secureStorage.delete(key: key);
  }

  static deleteAllFromSecureStorage() async {
    await _secureStorage.deleteAll();
  }

  static Future<List<Wallet>> readWallets() async {
    String? wallets = await _secureStorage.read(key: StorageKeys.wallets.toString());
    if (wallets == null || wallets.isEmpty) {
      return [];
    }

    return List.from(jsonDecode(wallets)).map((json) {
      return Wallet.fromJson(json);
    }).toList();
  }
}

enum StorageKeys {
  refreshToken,
  accessToken,
  address,
  wallets,
  pinCode,
  email,
}
