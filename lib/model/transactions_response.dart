// To parse this JSON data, do
//
//     final transactionsResponse = transactionsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:workquest_wallet_app/ui/transfer_page/confirm_page/mobx/confirm_transfer_store.dart';

TransactionsResponse transactionsResponseFromJson(String str) =>
    TransactionsResponse.fromJson(json.decode(str));

String transactionsResponseToJson(TransactionsResponse data) =>
    json.encode(data.toJson());

class TransactionsResponse {
  TransactionsResponse({
    this.ok,
    this.result,
  });

  bool? ok;
  Result? result;

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) =>
      TransactionsResponse(
        ok: json["ok"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "result": result == null ? null : result!.toJson(),
      };
}

class Result {
  Result({
    this.count,
    this.txs,
  });

  int? count;
  List<Tx>? txs;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        count: json["count"],
        txs: json["transactions"] == null
            ? null
            : List<Tx>.from(json["transactions"].map((x) => Tx.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "transactions": txs == null
            ? null
            : List<dynamic>.from(txs!.map((x) => x.toJson())),
      };
}

class Tx {
  Tx({
    this.hash,
    this.fromAddressHash,
    this.toAddressHash,
    this.token_contract_address_hash,
    this.gas,
    this.error,
    this.value,
    this.amount,
    this.gasUsed,
    this.gasPrice,
    this.blockNumber,
    this.insertedAt,
    this.block,
    this.tokenTransfers,
    this.coin,
  });

  String? hash;
  AddressHash? fromAddressHash;
  AddressHash? toAddressHash;
  AddressHash? token_contract_address_hash;
  String? gas;
  dynamic error;
  String? value;
  String? amount;
  String? gasUsed;
  String? gasPrice;
  int? blockNumber;
  DateTime? insertedAt;
  Block? block;
  List<TokenTransfer>? tokenTransfers;
  TYPE_COINS? coin;
  bool show = false;

  factory Tx.fromJson(Map<String, dynamic> json) => Tx(
        hash: json["hash"] ?? json["transaction_hash"],
        fromAddressHash: json["from_address_hash"] == null
            ? null
            : AddressHash.fromJson(json["from_address_hash"]),
        toAddressHash: json["to_address_hash"] == null
            ? null
            : AddressHash.fromJson(json["to_address_hash"]),
        token_contract_address_hash: json["token_contract_address_hash"] == null
            ? null
            : AddressHash.fromJson(json["token_contract_address_hash"]),
        gas: json["gas"],
        error: json["error"],
        value: json["value"],
        amount: json["amount"],
        gasUsed: json["gas_used"],
        gasPrice: json["gas_price"],
        blockNumber: json["block_number"],
        insertedAt: json["inserted_at"] == null
            ? null
            : DateTime.parse(json["inserted_at"]),
        block: json["block"] == null ? null : Block.fromJson(json["block"]),
        tokenTransfers: json["tokenTransfers"] == null
            ? null
            : List<TokenTransfer>.from(
                json["tokenTransfers"].map((x) => TokenTransfer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "hash": hash,
        "from_address_hash": fromAddressHash,
        "to_address_hash": toAddressHash,
        "token_contract_address_hash": token_contract_address_hash,
        "gas": gas,
        "error": error,
        "value": value,
        "amount": amount,
        "gas_used": gasUsed,
        "gas_price": gasPrice,
        "block_number": blockNumber,
        "inserted_at": insertedAt,
        "block": block,
        "tokenTransfers": tokenTransfers,
      };
}

class Block {
  Block({
    this.timestamp,
  });

  DateTime? timestamp;

  factory Block.fromJson(Map<String, dynamic> json) => Block(
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp,
      };
}

class AddressHash {
  AddressHash({
    this.hex,
    this.bech32,
  });

  String? hex;
  String? bech32;

  factory AddressHash.fromJson(Map<String, dynamic> json) => AddressHash(
        hex: json["hex"],
        bech32: json["bech32"],
      );

  Map<String, dynamic> toJson() => {
        "hex": hex,
        "bech32": bech32,
      };
}

class TokenTransfer {
  TokenTransfer({
    this.amount,
  });

  String? amount;

  factory TokenTransfer.fromJson(Map<String, dynamic> json) => TokenTransfer(
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
      };
}
