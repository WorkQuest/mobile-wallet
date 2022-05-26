import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import '../../../../utils/alert_dialog.dart';
import '../../../page_router.dart';
import '../../../widgets/animation/login_button.dart';
import '../../../widgets/default_textfield.dart';
import '../../../widgets/observer_consumer.dart';
import '../../login_page/login_page.dart';
import '../sign_up/mobx/sign_up_store.dart';

class ImportWalletPage extends StatefulWidget {
  const ImportWalletPage({Key? key}) : super(key: key);

  @override
  _ImportWalletPageState createState() => _ImportWalletPageState();
}

class _ImportWalletPageState extends State<ImportWalletPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _mnemonicController;
  late SignUpStore store;

  @override
  void initState() {
    super.initState();
    _mnemonicController = TextEditingController();
    store = SignUpStore();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: const DefaultAppBar(
          title: "Import Wallet",
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mnemonic",
                ),
                const SizedBox(
                  height: 10.0,
                  width: double.infinity,
                ),
                DefaultTextField(
                  controller: _mnemonicController,
                  hint: "Enter mnemonic",
                  isPassword: true,
                  onChanged: store.setMnemonic,
                  validator: (value) {
                    if (_mnemonicController.text.length <= 24) {
                      return "errors.smallNumberWords".tr();
                    }
                    if (_mnemonicController.text.split(' ').toList().length <
                        12) {
                      return "errors.incorrectMnemonicFormat".tr();
                    }
                    return null;
                  },
                  inputFormatters: [],
                  suffixIcon: null,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Spacer(),
                ObserverListener<SignUpStore>(
                  store: store,
                  onFailure: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    return false;
                  },
                  onSuccess: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    await AlertDialogUtils.showSuccessDialog(context);
                    PageRouter.pushNewRemoveRoute(context, const LoginPage());
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: double.infinity,
                      ),
                      LoginButton(
                        enabled: store.isLoading,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            AlertDialogUtils.showLoadingDialog(context);
                            store.openWallet();
                          }
                        },
                        title: "Import",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
