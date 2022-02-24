import 'dart:typed_data';

import 'package:bech32/bech32.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:hex/hex.dart';
import 'package:web3dart/credentials.dart';

const _baseDerivationPath = "m/44'/60'/0'/0/0";

abstract class AddressServiceI {
  String generateMnemonic();

  bool validateMnemonic(String mnemonic);

  String getPrivateKey(String mnemonic);

  String getPublicKey(String privateKey);

  Future<EthereumAddress> getPublicAddress(String privateKey);

  Future<String> hexToBech32(String privateKey);

  Future<String> bech32ToHex(String privateKey);
}

class AddressService implements AddressServiceI {
  static final AddressService _instance = AddressService._internal();

  factory AddressService() => _instance;

  AddressService._internal();

  @override
  String generateMnemonic() {
    try {
      return bip39.generateMnemonic(strength: 128);
    } catch (e) {
      throw Exception("Error generating mnemonic");
    }
  }

  @override
  bool validateMnemonic(String mnemonic) {
    try {
      return bip39.validateMnemonic(mnemonic);
    } catch (e) {
      throw Exception("Error validate mnemonic");
    }
  }


  @override
  String getPrivateKey(String mnemonic) {
    try {
      final seed = bip39.mnemonicToSeedHex(mnemonic);

      final bip32.BIP32 root = bip32.BIP32.fromSeed(
        Uint8List.fromList(
          HEX.decode(seed),
        ),
      );
      final bip32.BIP32 child = root.derivePath(_baseDerivationPath);
      final privateKey = HEX.encode(child.privateKey!.toList());

      return privateKey;
    } catch (e) {
      throw Exception("Error getting private key");
    }
  }

  @override
  Future<EthereumAddress> getPublicAddress(String privateKey) async {
    try {
      final private = EthPrivateKey.fromHex(privateKey);
      final address = await private.extractAddress();
      return address;
    } catch (e) {
      throw Exception("Error getting address");
    }
  }

  @override
  String getPublicKey(String privateKey) {
    try {
      final private = EthPrivateKey.fromHex(privateKey);
      final public = HEX.encode(private.encodedPublicKey);
      return public;
    } catch (e) {
      throw Exception("Error getting public key");
    }
  }

  @override
  Future<String> hexToBech32(String privateKey) async {
    final address = await getPublicAddress(privateKey);
    print(address.hexNo0x);

    final hex = HEX.decode(address.hexNo0x);
    final bech32 = Bech32Encoder.encode('wq', Uint8List.fromList(hex));
    print(bech32);
    return bech32;
  }

  @override
  Future<String> bech32ToHex(String privateKey) async {
    final bech32 = await hexToBech32(privateKey);

    final bechToHex = Bech32Encoder.decode(bech32);
    final result = HEX.encode(bechToHex.toList());
    print(result);

    return result;
  }
}

class Bech32Encoder {
  /// Encodes the given data using the Bech32 encoding with the
  /// given human readable part
  static String encode(String humanReadablePart, Uint8List data) {
    final List<int> converted = _convertBits(data, 8, 5);
    final bech32Codec = Bech32Codec();
    final bech32Data = Bech32(humanReadablePart, converted as Uint8List);
    return bech32Codec.encode(bech32Data);
  }

  /// for bech32 coding
  static Uint8List _convertBits(
    List<int> data,
    int from,
    int to, {
    bool pad = true,
  }) {
    var acc = 0;
    var bits = 0;
    final result = <int>[];
    final maxv = (1 << to) - 1;

    for (var v in data) {
      if (v < 0 || (v >> from) != 0) {
        throw Exception();
      }
      acc = (acc << from) | v;
      bits += from;
      while (bits >= to) {
        bits -= to;
        result.add((acc >> bits) & maxv);
      }
    }

    if (pad) {
      if (bits > 0) {
        result.add((acc << (to - bits)) & maxv);
      }
    } else if (bits >= from) {
      throw Exception('illegal zero padding');
    } else if (((acc << (to - bits)) & maxv) != 0) {
      throw Exception('non zero');
    }

    return Uint8List.fromList(result);
  }

  static Uint8List decode(String data) {
    final bech32Codec = Bech32Codec();
    final bech32Data = bech32Codec.decode(data);
    final list = _convertBits(bech32Data.data, 5, 8);
    return Uint8List.fromList(list);
  }
}
