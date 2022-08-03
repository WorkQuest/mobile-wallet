import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/session_repository.dart';

class ButtonToExplorer extends StatelessWidget {
  const ButtonToExplorer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14.0),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'wallet.goExplorer'.tr(),
              style:
                  const TextStyle(fontSize: 16, color: AppColor.enabledButton),
            ),
            const SizedBox(
              width: 14.0,
            ),
            SvgPicture.asset(
              Images.explorerToIcon,
              width: 16,
              height: 16,
            ),
          ],
        ),
        onPressed: _onPressedGoToExplorer,
      ),
    );
  }

  _onPressedGoToExplorer() {
    final _urlExplorer =
        GetIt.I.get<SessionRepository>().getConfigNetwork().urlExplorer +
            GetIt.I.get<SessionRepository>().userAddress;
    launchUrl(Uri.parse(_urlExplorer));
  }
}
