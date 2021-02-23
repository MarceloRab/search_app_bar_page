import 'package:get/state_manager.dart';

abstract class SeacherBase<T> {
  final RxBool _isModSearch = false.obs;

  bool get isModSearch => _isModSearch.value;

  set isModSearch(bool value) => _isModSearch.value = value;

  final RxString rxSearch = ''.obs;

  final RxBool bancoInit = false.obs;

  set bancoInitValue(bool value) => bancoInit.value = value;

  bool get bancoInitValue => bancoInit.value;

  /* final StreamController<bool> bancoInit = StreamController<bool>();

  set bancoInitValue(bool value) => bancoInit.stream.last = value;

  bool get bancoInitValue => bancoInit.value;
*/
  void sortCompareList(List<T> list);

  bool sortCompare = true;
}
