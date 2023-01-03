import 'dart:convert';

import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';

TxOtherNetworkResponse txOtherNetworkResponseFromJson(String str) => TxOtherNetworkResponse.fromJson(json.decode(str));

String txOtherNetworkResponseToJson(TxOtherNetworkResponse data) => json.encode(data.toJson());

class TxOtherNetworkResponse {
  TxOtherNetworkResponse({
    this.status,
    this.message,
    this.result,
  });

  String? status;
  String? message;
  List<TxOther>? result;

  factory TxOtherNetworkResponse.fromJson(Map<String, dynamic> json) => TxOtherNetworkResponse(
        status: json["status"],
        message: json["message"],
        result: json["result"] == null ? null : List<TxOther>.from(json["result"].map((x) => TxOther.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result == null ? null : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class TxOther {
  TxOther({
    this.blockNumber,
    this.blockHash,
    this.timeStamp,
    this.hash,
    this.nonce,
    this.transactionIndex,
    this.from,
    this.to,
    this.value,
    this.gas,
    this.gasPrice,
    this.input,
    this.methodId,
    this.functionName,
    this.contractAddress,
    this.cumulativeGasUsed,
    this.txreceiptStatus,
    this.gasUsed,
    this.confirmations,
    this.isError,
  });

  String? blockNumber;
  String? blockHash;
  String? timeStamp;
  String? hash;
  String? nonce;
  String? transactionIndex;
  String? from;
  String? to;
  String? value;
  String? gas;
  String? gasPrice;
  String? input;
  String? methodId;
  String? functionName;
  String? contractAddress;
  String? cumulativeGasUsed;
  String? txreceiptStatus;
  String? gasUsed;
  String? confirmations;
  String? isError;

  factory TxOther.fromJson(Map<String, dynamic> json) => TxOther(
        blockNumber: json["blockNumber"],
        blockHash: json["blockHash"],
        timeStamp: json["timeStamp"],
        hash: json["hash"],
        nonce: json["nonce"],
        transactionIndex: json["transactionIndex"],
        from: json["from"],
        to: json["to"],
        value: json["value"],
        gas: json["gas"],
        gasPrice: json["gasPrice"],
        input: json["input"],
        methodId: json["methodId"],
        functionName: json["functionName"],
        contractAddress: json["contractAddress"],
        cumulativeGasUsed: json["cumulativeGasUsed"],
        txreceiptStatus: json["txreceipt_status"],
        gasUsed: json["gasUsed"],
        confirmations: json["confirmations"],
        isError: json["isError"],
      );

  Map<String, dynamic> toJson() => {
        "blockNumber": blockNumber,
        "blockHash": blockHash,
        "timeStamp": timeStamp,
        "hash": hash,
        "nonce": nonce,
        "transactionIndex": transactionIndex,
        "from": from,
        "to": to,
        "value": value,
        "gas": gas,
        "gasPrice": gasPrice,
        "input": input,
        "methodId": methodId,
        "functionName": functionName,
        "contractAddress": contractAddress,
        "cumulativeGasUsed": cumulativeGasUsed,
        "txreceipt_status": txreceiptStatus,
        "gasUsed": gasUsed,
        "confirmations": confirmations,
        "isError": isError,
      };

  TokenSymbols getSymbol() {
    return Web3Utils.getSymbolFromAddress((contractAddress ?? '').isEmpty ? null : contractAddress);
  }

  DateTime getInsertedAt() {
    return DateTime.fromMillisecondsSinceEpoch(
        BigInt.parse(timeStamp ?? DateTime.now().second.toString()).toInt() * 1000);
  }
}
