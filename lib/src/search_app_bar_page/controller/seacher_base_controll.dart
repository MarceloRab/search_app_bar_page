import 'package:get_state_manager/get_state_manager.dart';

abstract class SeacherBase {
  final RxBool _isModSearch = false.obs;

  bool get isModSearch => _isModSearch.value;

  set isModSearch(bool value) => _isModSearch.value = value;

  final RxString rxSearch = ''.obs;

  final RxBool _bancoInit = false.obs;

  set bancoInit(bool value) => _bancoInit.value = value;

  bool get bancoInit => _bancoInit.value;
}
