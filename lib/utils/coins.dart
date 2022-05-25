import 'package:workquest_wallet_app/constants.dart';

import 'package:workquest_wallet_app/ui/transfer_page/confirm_page/mobx/confirm_transfer_store.dart';

class CoinsUtils {
  static TYPE_COINS getTypeCoin(String address, AddressCoins addresses) {
    if (address == addresses.wusd) {
      return TYPE_COINS.wusd;
    } else if (address == addresses.weth) {
      return TYPE_COINS.wEth;
    } else if (address == addresses.wbnb) {
      return TYPE_COINS.wBnb;
    } else if (address == addresses.usdt) {
      return TYPE_COINS.usdt;
    } else {
      return TYPE_COINS.wqt;
    }
  }

  static String getAddressCoin(TYPE_COINS type, AddressCoins addresses) {
    switch (type) {
      case TYPE_COINS.wqt:
        return '';
      case TYPE_COINS.wusd:
        return addresses.wusd;
      case TYPE_COINS.wBnb:
        return addresses.wbnb;
      case TYPE_COINS.wEth:
        return addresses.weth;
      case TYPE_COINS.usdt:
        return addresses.usdt;
    }
  }
}
