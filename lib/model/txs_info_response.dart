class TxInfoResponse {
  bool? ok;
  Result? result;

  TxInfoResponse({this.ok, this.result});

  TxInfoResponse.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    result =
    json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ok'] = ok;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  String? hash;
  String? input;
  String? blockHash;
  FromAddressHash? fromAddressHash;
  FromAddressHash? toAddressHash;
  dynamic createdContractAddressHash;
  dynamic oldBlockHash;
  String? cumulativeGasUsed;
  dynamic error;
  String? gas;
  String? gasPrice;
  String? gasUsed;
  int? index;
  int? nonce;
  String? r;
  String? s;
  int? status;
  String? v;
  String? value;
  String? insertedAt;
  String? updatedAt;
  int? blockNumber;
  dynamic createdContractCodeIndexedAt;
  dynamic earliestProcessingStart;
  dynamic revertReason;
  dynamic maxPriorityFeePerGas;
  dynamic maxFeePerGas;
  int? type;
  FromAddress? fromAddress;
  Block? block;
  ToAddress? toAddress;
  dynamic createdContractAddress;
  List<TokenTransfers>? tokenTransfers;
  List<Logs>? logs;

  Result(
      {this.hash,
        this.input,
        this.blockHash,
        this.fromAddressHash,
        this.toAddressHash,
        this.createdContractAddressHash,
        this.oldBlockHash,
        this.cumulativeGasUsed,
        this.error,
        this.gas,
        this.gasPrice,
        this.gasUsed,
        this.index,
        this.nonce,
        this.r,
        this.s,
        this.status,
        this.v,
        this.value,
        this.insertedAt,
        this.updatedAt,
        this.blockNumber,
        this.createdContractCodeIndexedAt,
        this.earliestProcessingStart,
        this.revertReason,
        this.maxPriorityFeePerGas,
        this.maxFeePerGas,
        this.type,
        this.fromAddress,
        this.block,
        this.toAddress,
        this.createdContractAddress,
        this.tokenTransfers,
        this.logs});

  Result.fromJson(Map<String, dynamic> json) {
    hash = json['hash'];
    input = json['input'];
    blockHash = json['block_hash'];
    fromAddressHash = json['from_address_hash'] != null
        ? FromAddressHash.fromJson(json['from_address_hash'])
        : null;
    toAddressHash = json['to_address_hash'] != null
        ? FromAddressHash.fromJson(json['to_address_hash'])
        : null;
    createdContractAddressHash = json['created_contract_address_hash'];
    oldBlockHash = json['old_block_hash'];
    cumulativeGasUsed = json['cumulative_gas_used'];
    error = json['error'];
    gas = json['gas'];
    gasPrice = json['gas_price'];
    gasUsed = json['gas_used'];
    index = json['index'];
    nonce = json['nonce'];
    r = json['r'];
    s = json['s'];
    status = json['status'];
    v = json['v'];
    value = json['value'];
    insertedAt = json['inserted_at'];
    updatedAt = json['updated_at'];
    blockNumber = json['block_number'];
    createdContractCodeIndexedAt = json['created_contract_code_indexed_at'];
    earliestProcessingStart = json['earliest_processing_start'];
    revertReason = json['revert_reason'];
    maxPriorityFeePerGas = json['max_priority_fee_per_gas'];
    maxFeePerGas = json['max_fee_per_gas'];
    type = json['type'];
    fromAddress = json['fromAddress'] != null
        ? FromAddress.fromJson(json['fromAddress'])
        : null;
    block = json['block'] != null ? Block.fromJson(json['block']) : null;
    toAddress = json['toAddress'] != null
        ? ToAddress.fromJson(json['toAddress'])
        : null;
    createdContractAddress = json['createdContractAddress'];
    if (json['tokenTransfers'] != null) {
      tokenTransfers = <TokenTransfers>[];
      json['tokenTransfers'].forEach((v) {
        tokenTransfers!.add(TokenTransfers.fromJson(v));
      });
    }
    if (json['logs'] != null) {
      logs = <Logs>[];
      json['logs'].forEach((v) {
        logs!.add(Logs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hash'] = hash;
    data['input'] = input;
    data['block_hash'] = blockHash;
    if (fromAddressHash != null) {
      data['from_address_hash'] = fromAddressHash!.toJson();
    }
    if (toAddressHash != null) {
      data['to_address_hash'] = toAddressHash!.toJson();
    }
    data['created_contract_address_hash'] = createdContractAddressHash;
    data['old_block_hash'] = oldBlockHash;
    data['cumulative_gas_used'] = cumulativeGasUsed;
    data['error'] = error;
    data['gas'] = gas;
    data['gas_price'] = gasPrice;
    data['gas_used'] = gasUsed;
    data['index'] = index;
    data['nonce'] = nonce;
    data['r'] = r;
    data['s'] = s;
    data['status'] = status;
    data['v'] = v;
    data['value'] = value;
    data['inserted_at'] = insertedAt;
    data['updated_at'] = updatedAt;
    data['block_number'] = blockNumber;
    data['created_contract_code_indexed_at'] =
        createdContractCodeIndexedAt;
    data['earliest_processing_start'] = earliestProcessingStart;
    data['revert_reason'] = revertReason;
    data['max_priority_fee_per_gas'] = maxPriorityFeePerGas;
    data['max_fee_per_gas'] = maxFeePerGas;
    data['type'] = type;
    if (fromAddress != null) {
      data['fromAddress'] = fromAddress!.toJson();
    }
    if (block != null) {
      data['block'] = block!.toJson();
    }
    if (toAddress != null) {
      data['toAddress'] = toAddress!.toJson();
    }
    data['createdContractAddress'] = createdContractAddress;
    if (tokenTransfers != null) {
      data['tokenTransfers'] =
          tokenTransfers!.map((v) => v.toJson()).toList();
    }
    if (logs != null) {
      data['logs'] = logs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FromAddressHash {
  String? hex;
  String? bech32;

  FromAddressHash({this.hex, this.bech32});

  FromAddressHash.fromJson(Map<String, dynamic> json) {
    hex = json['hex'];
    bech32 = json['bech32'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hex'] = hex;
    data['bech32'] = bech32;
    return data;
  }
}

class FromAddress {
  FromAddressHash? hash;
  dynamic contractCode;
  String? fetchedCoinBalance;
  String? fetchedCoinBalanceBlockNumber;
  String? insertedAt;
  String? updatedAt;
  int? nonce;
  bool? decompiled;
  bool? verified;

  FromAddress(
      {this.hash,
        this.contractCode,
        this.fetchedCoinBalance,
        this.fetchedCoinBalanceBlockNumber,
        this.insertedAt,
        this.updatedAt,
        this.nonce,
        this.decompiled,
        this.verified});

  FromAddress.fromJson(Map<String, dynamic> json) {
    hash = json['hash'] != null
        ? FromAddressHash.fromJson(json['hash'])
        : null;
    contractCode = json['contract_code'];
    fetchedCoinBalance = json['fetched_coin_balance'];
    fetchedCoinBalanceBlockNumber = json['fetched_coin_balance_block_number'];
    insertedAt = json['inserted_at'];
    updatedAt = json['updated_at'];
    nonce = json['nonce'];
    decompiled = json['decompiled'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (hash != null) {
      data['hash'] = hash!.toJson();
    }
    data['contract_code'] = contractCode;
    data['fetched_coin_balance'] = fetchedCoinBalance;
    data['fetched_coin_balance_block_number'] =
        fetchedCoinBalanceBlockNumber;
    data['inserted_at'] = insertedAt;
    data['updated_at'] = updatedAt;
    data['nonce'] = nonce;
    data['decompiled'] = decompiled;
    data['verified'] = verified;
    return data;
  }
}

class Block {
  String? hash;
  FromAddressHash? minerHash;
  String? nonce;
  String? parentHash;
  bool? consensus;
  String? difficulty;
  String? gasLimit;
  String? gasUsed;
  String? number;
  int? size;
  String? timestamp;
  String? totalDifficulty;
  String? insertedAt;
  String? updatedAt;
  bool? refetchNeeded;
  String? baseFeePerGas;

  Block(
      {this.hash,
        this.minerHash,
        this.nonce,
        this.parentHash,
        this.consensus,
        this.difficulty,
        this.gasLimit,
        this.gasUsed,
        this.number,
        this.size,
        this.timestamp,
        this.totalDifficulty,
        this.insertedAt,
        this.updatedAt,
        this.refetchNeeded,
        this.baseFeePerGas});

  Block.fromJson(Map<String, dynamic> json) {
    hash = json['hash'];
    minerHash = json['miner_hash'] != null
        ? FromAddressHash.fromJson(json['miner_hash'])
        : null;
    nonce = json['nonce'];
    parentHash = json['parent_hash'];
    consensus = json['consensus'];
    difficulty = json['difficulty'];
    gasLimit = json['gas_limit'];
    gasUsed = json['gas_used'];
    number = json['number'];
    size = json['size'];
    timestamp = json['timestamp'];
    totalDifficulty = json['total_difficulty'];
    insertedAt = json['inserted_at'];
    updatedAt = json['updated_at'];
    refetchNeeded = json['refetch_needed'];
    baseFeePerGas = json['base_fee_per_gas'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hash'] = hash;
    if (minerHash != null) {
      data['miner_hash'] = minerHash!.toJson();
    }
    data['nonce'] = nonce;
    data['parent_hash'] = parentHash;
    data['consensus'] = consensus;
    data['difficulty'] = difficulty;
    data['gas_limit'] = gasLimit;
    data['gas_used'] = gasUsed;
    data['number'] = number;
    data['size'] = size;
    data['timestamp'] = timestamp;
    data['total_difficulty'] = totalDifficulty;
    data['inserted_at'] = insertedAt;
    data['updated_at'] = updatedAt;
    data['refetch_needed'] = refetchNeeded;
    data['base_fee_per_gas'] = baseFeePerGas;
    return data;
  }
}

class ToAddress {
  FromAddressHash? hash;
  String? contractCode;
  String? fetchedCoinBalance;
  String? fetchedCoinBalanceBlockNumber;
  String? insertedAt;
  String? updatedAt;
  dynamic nonce;
  bool? decompiled;
  bool? verified;

  ToAddress(
      {this.hash,
        this.contractCode,
        this.fetchedCoinBalance,
        this.fetchedCoinBalanceBlockNumber,
        this.insertedAt,
        this.updatedAt,
        this.nonce,
        this.decompiled,
        this.verified});

  ToAddress.fromJson(Map<String, dynamic> json) {
    hash = json['hash'] != null
        ? FromAddressHash.fromJson(json['hash'])
        : null;
    contractCode = json['contract_code'];
    fetchedCoinBalance = json['fetched_coin_balance'];
    fetchedCoinBalanceBlockNumber = json['fetched_coin_balance_block_number'];
    insertedAt = json['inserted_at'];
    updatedAt = json['updated_at'];
    nonce = json['nonce'];
    decompiled = json['decompiled'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (hash != null) {
      data['hash'] = hash!.toJson();
    }
    data['contract_code'] = contractCode;
    data['fetched_coin_balance'] = fetchedCoinBalance;
    data['fetched_coin_balance_block_number'] =
        fetchedCoinBalanceBlockNumber;
    data['inserted_at'] = insertedAt;
    data['updated_at'] = updatedAt;
    data['nonce'] = nonce;
    data['decompiled'] = decompiled;
    data['verified'] = verified;
    return data;
  }
}

class TokenTransfers {
  String? amount;

  TokenTransfers({this.amount});

  TokenTransfers.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    return data;
  }
}

class Logs {
  String? data;
  FromAddressHash? addressHash;
  String? transactionHash;
  String? blockHash;
  int? index;
  dynamic type;
  String? firstTopic;
  String? secondTopic;
  String? thirdTopic;
  dynamic fourthTopic;
  String? insertedAt;
  String? updatedAt;
  int? blockNumber;

  Logs(
      {this.data,
        this.addressHash,
        this.transactionHash,
        this.blockHash,
        this.index,
        this.type,
        this.firstTopic,
        this.secondTopic,
        this.thirdTopic,
        this.fourthTopic,
        this.insertedAt,
        this.updatedAt,
        this.blockNumber});

  Logs.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    addressHash = json['address_hash'] != null
        ? FromAddressHash.fromJson(json['address_hash'])
        : null;
    transactionHash = json['transaction_hash'];
    blockHash = json['block_hash'];
    index = json['index'];
    type = json['type'];
    firstTopic = json['first_topic'];
    secondTopic = json['second_topic'];
    thirdTopic = json['third_topic'];
    fourthTopic = json['fourth_topic'];
    insertedAt = json['inserted_at'];
    updatedAt = json['updated_at'];
    blockNumber = json['block_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data;
    if (addressHash != null) {
      data['address_hash'] = addressHash!.toJson();
    }
    data['transaction_hash'] = transactionHash;
    data['block_hash'] = blockHash;
    data['index'] = index;
    data['type'] = type;
    data['first_topic'] = firstTopic;
    data['second_topic'] = secondTopic;
    data['third_topic'] = thirdTopic;
    data['fourth_topic'] = fourthTopic;
    data['inserted_at'] = insertedAt;
    data['updated_at'] = updatedAt;
    data['block_number'] = blockNumber;
    return data;
  }
}
