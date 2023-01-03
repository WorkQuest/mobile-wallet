import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/io.dart';
import 'package:workquest_wallet_app/model/transactions_response.dart';
import 'package:workquest_wallet_app/model/trx_ethereum_response.dart';
import 'package:workquest_wallet_app/repository/session_repository.dart';
import 'package:workquest_wallet_app/service/address_service.dart';
import 'package:workquest_wallet_app/ui/wallet_page/transactions/mobx/transactions_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/mobx/wallet_store.dart';

class WebSocket {
  static final WebSocket _instance = WebSocket._internal();

  factory WebSocket() => _instance;

  WebSocket._internal();

  IOWebSocketChannel? channel;

  bool? shouldReconnectFlag;

  int closeCode = 4001;

  String? currentWss;

  init() async {
    shouldReconnectFlag = true;
    currentWss = GetIt.I.get<SessionRepository>().getConfigNetworkWorknet().wss;
    channel = IOWebSocketChannel.connect(currentWss!);
    channel!.sink.add("""
    {
        "jsonrpc": "2.0",
        "method": "subscribe",
        "id": 0,
        "params": {
            "query": "tm.event='Tx'"
        }
    }
    """);

    channel!.stream.listen((message) {
      // log("WebSocket message: $message");
      var jsonResponse = jsonDecode(message);
      handleSubscription(jsonResponse);
    }, onDone: () async {
      if (shouldReconnectFlag!) {
        init();
      }
      // print("WebSocket onDone ${channel!.closeReason}");
    }, onError: (error) {
      // print("WebSocket error: $error");
    });
  }

  void closeWebSocket() {
    shouldReconnectFlag = false;
    channel!.sink.close(closeCode, "closeCode");
  }

  _closeWalletSocket() {
    if (channel != null) {
      channel!.sink.close();
    }
  }

  reconnectWalletSocket() {
    if (currentWss ==
        GetIt.I.get<SessionRepository>().getConfigNetworkWorknet().wss) {
      return;
    }
    _closeWalletSocket();
  }

  String get myAddress => GetIt.I.get<SessionRepository>().userWallet!.address!;

  void handleSubscription(dynamic jsonResponse) async {
    try {
      final transaction = TrxEthereumResponse.fromJson(jsonResponse);
      final _events = transaction.result?.events;
      final _recipient = _events?['ethereum_tx.recipient']?[0];
      late String? _sender;
      try {
        _sender = _events?['message.sender']?[3].toString().toLowerCase();
      } catch (e) {
        _sender = _events?['message.sender']?[2].toString().toLowerCase();
      }
      final _txHash =
          _events?['ethereum_tx.ethereumTxHash']?[0]?.toString().toLowerCase();
      final _blockNumber = _events?['tx.height']?[0];
      final _block = DateTime.now();
      final _value = _events?['ethereum_tx.amount']?[0];
      final _transactionFee =
          _events?['tx.fee']?[0].toString().split('a').first;

      if (_recipient.toString().toLowerCase() == myAddress.toLowerCase()) {
        if (double.parse(_value) == 0.0) {
          await Future.delayed(const Duration(seconds: 9));
          GetIt.I.get<WalletStore>().getCoins(isForce: false);
          GetIt.I.get<TransactionsStore>().getTransactions();
        } else {
          final _tx = Tx(
            hash: _txHash,
            fromAddressHash: AddressHash(
              bech32: AddressService.hexToBech32(_sender!),
              hex: _sender,
            ),
            toAddressHash: AddressHash(
              bech32: AddressService.hexToBech32(_recipient),
              hex: _recipient,
            ),
            amount: _value,
            blockNumber: int.parse(_blockNumber),
            gasUsed: _transactionFee,
            insertedAt: _block,
            block: Block(timestamp: _block),
          );
          GetIt.I.get<TransactionsStore>().addTransaction(_tx);
          GetIt.I.get<WalletStore>().getCoins(isForce: false);
        }
      } else {
        final _txLog = json.decode(transaction
            .result!.events!['tx_log.txLog']![0]
            .toString()
            .replaceAll('\\', ""));
        final _address = _txLog['topics'][2].toString().split('x').first +
            'x' +
            _txLog['topics'][2].toString().split('x').last.substring(24);
        if (_address.toLowerCase() == myAddress) {
          await Future.delayed(const Duration(seconds: 9));
          GetIt.I.get<WalletStore>().getCoins(isForce: false);
          GetIt.I.get<TransactionsStore>().getTransactions();
        }
      }
    } catch (e) {
      // print('web socket e - $e\ntrace - $trace');
    }
  }
}
