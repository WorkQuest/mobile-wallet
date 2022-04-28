import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/page_router.dart';
import 'package:workquest_wallet_app/ui/sign_up_page/sign_up_choose_role/sign_up_approve_role.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';

import '../../../constants.dart';
import 'mobx/sign_up_role_store.dart';

class SignUpChooseRole extends StatefulWidget {
  final String email;

  const SignUpChooseRole({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  _SignUpChooseRoleState createState() => _SignUpChooseRoleState();
}

class _SignUpChooseRoleState extends State<SignUpChooseRole> {
  final store = SignUpRoleStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'meta.back'.tr(),
        titleCenter: false,
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
      body: LayoutWithScroll(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                'role.choose'.tr(),
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 40,
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  store.setRole(UserRole.employer);
                  PageRouter.pushNewRoute(
                    context,
                    SignUpApproveRole(
                      isWorker: false,
                      store: store,
                      email: widget.email,
                      child: _CardRole(
                        title: 'role.employer'.tr(),
                        description: 'role.employerWant'.tr(),
                        imagePath: Images.employerImage,
                      ),
                    ),
                  );
                },
                child: _CardRole(
                  title: 'role.employer'.tr(),
                  description: 'role.employerWant'.tr(),
                  imagePath: Images.employerImage,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  store.setRole(UserRole.worker);
                  PageRouter.pushNewRoute(
                    context,
                    SignUpApproveRole(
                      isWorker: true,
                      store: store,
                      email: widget.email,
                      child: _CardRole(
                          title: 'role.worker'.tr(),
                          description: 'role.workerWant'.tr(),
                          imagePath: Images.workerImage,
                          isWorker: true),
                    ),
                  );
                },
                child: _CardRole(
                  title: 'role.worker'.tr(),
                  description: 'role.workerWant'.tr(),
                  imagePath: Images.workerImage,
                  isWorker: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardRole extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final bool isWorker;

  const _CardRole({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.isWorker = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isWorker ? Colors.white : Colors.black;
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.fill,
        ),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600, color: color),
                ),
                const SizedBox(
                  height: 8,
                ),
                Flexible(
                  child: Text(
                    description,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: color),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
          ),
        ],
      ),
    );
  }
}
