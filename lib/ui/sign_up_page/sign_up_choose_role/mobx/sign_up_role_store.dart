import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';

part 'sign_up_role_store.g.dart';

class SignUpRoleStore = SignUpRoleStoreBase with _$SignUpRoleStore;

abstract class SignUpRoleStoreBase extends IStore<bool> with Store {

  @observable
  UserRole role = UserRole.worker;

  @observable
  bool privacyPolicy = false;

  @observable
  bool termsConditions = false;

  @observable
  bool amlCtfPolicy = false;

  @action
  setRole(UserRole value) => role = value;

  @action
  setPrivacyPolicy(bool value) => privacyPolicy = value;

  @action
  setTermsConditions(bool value) => termsConditions = value;

  @action
  setAmlCtfPolicy(bool value) => amlCtfPolicy = value;

  @computed
  bool get canAgreeRole => privacyPolicy & termsConditions & amlCtfPolicy;
}

enum UserRole {
  employer, worker
}
