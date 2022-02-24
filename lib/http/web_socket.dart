import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/io.dart';
import 'package:workquest_wallet_app/model/trx_ethereum_response.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/ui/wallet_page/transactions/mobx/transactions_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/mobx/wallet_store.dart';

class WebSocket {
  static final WebSocket _instance = WebSocket._internal();

  factory WebSocket() => _instance;

  WebSocket._internal();

  IOWebSocketChannel? channel;

  bool? shouldReconnectFlag;

  int closeCode = 4001;

  init() async {
    // print('web socket init');
    shouldReconnectFlag = true;
    channel =
        IOWebSocketChannel.connect("wss://dev-node-nyc3.workquest.co/tendermint-rpc/websocket");
    final address = channel!.sink.add("""
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
      // print("WebSocket message: $message");
      var jsonResponse = jsonDecode(message);
      handleSubscription(jsonResponse);
    }, onDone: () async {
      if (shouldReconnectFlag!) {
        init();
      }
      print("WebSocket onDone ${channel!.closeReason}");
    }, onError: (error) {
      print("WebSocket error: $error");
    });
  }

  void closeWebSocket() {
    print('closeWebSocket');
    shouldReconnectFlag = false;
    channel!.sink.close(closeCode, "closeCode");
  }

  String get myAddress => AccountRepository().userAddress!;

  void handleSubscription(dynamic jsonResponse) async {
    try {
      final transaction = TrxEthereumResponse.fromJson(jsonResponse);

      final isWQT =
          transaction.result!.events!['ethereum_tx.recipient']!.first.toString().toLowerCase() ==
              '0x917dc1a9E858deB0A5bDCb44C7601F655F728DfE'.toLowerCase();

      if (isWQT) {
        final decode = json.decode(transaction.result!.events!['tx_log.txLog']!.first);
        if ((decode['topics'] as List<String>).last.substring(26) ==
            myAddress.substring(2)) {
          await Future.delayed(const Duration(seconds: 2));
          GetIt.I.get<WalletStore>().getCoins(isForce: false);
          GetIt.I.get<TransactionsStore>().getTransactions(isForce: false);
        }
      } else {
        if (transaction.result!.events!['ethereum_tx.recipient']!.first.toString().toLowerCase() == myAddress.toLowerCase()) {
          await Future.delayed(const Duration(seconds: 2));
          GetIt.I.get<WalletStore>().getCoins(isForce: false);
          GetIt.I.get<TransactionsStore>().getTransactions(isForce: false);
        }
      }
    } catch (e, trace) {
      // print('web socket e - $e\ntrace - $trace');
    }
  }
}
