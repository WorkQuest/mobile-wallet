import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:workquest_wallet_app/service/address_service.dart';

class Wallet extends Equatable {
  final String? address;
  final String? privateKey;
  final String? publicKey;
  final String? title;

  const Wallet({
    required this.address,
    required this.privateKey,
    required this.publicKey,
    this.title = "",
  })  : assert(privateKey != null),
        assert(publicKey != null);

  @override
  List<Object> get props {
    return [address!, privateKey!, publicKey!];
  }

  static Future<Wallet> derive(String mnemonic) async {
    mnemonic = mnemonic.trim();
    if (!AddressService.validateMnemonic(mnemonic)) {
      throw FormatException("errors.invalidMnemonic".tr());
    }

    final privateKey = AddressService.getPrivateKey(mnemonic);
    final publicKey = AddressService.getPublicKey(privateKey);
    final address = await AddressService.getPublicAddress(privateKey);

    return Wallet(
      address: address.hex,
      publicKey: publicKey,
      privateKey: privateKey,
    );
  }

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      address: json["hex_address"],
      publicKey: json['public_key'],
      privateKey: json['private_key'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'hex_address': address,
        'public_key': publicKey,
        'private_key': privateKey,
        'title': title,
      };
}
