import 'package:mobx/mobx.dart';

part 'i_store.g.dart';

abstract class IStore<T> extends _IStore<T> with _$IStore {}

abstract class _IStore<T> with Store {
  @observable
  bool isLoading = false;

  @observable
  T? successData;

  @observable
  String? errorMessage;

  @computed
  bool get isSuccess {
    return successData != null;
  }

  void onSuccess(T successData) {
    this.successData = successData;
    isLoading = false;
    errorMessage = null;
  }

  void onError(String errorMessage, [T? successData]) {
    this.successData = successData;
    this.errorMessage = errorMessage;
    isLoading = false;
  }

  void onLoading([T? successData]) {
    this.successData = successData;
    errorMessage = null;
    isLoading = true;
  }
}
