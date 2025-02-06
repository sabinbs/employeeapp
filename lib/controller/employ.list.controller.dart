import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../database/databasehelper.dart';
import '../modal/employee.modal.dart';

class EmployeeListController extends GetxController{

  RxList<Employee> employeesList = <Employee>[].obs;

  RxList<Employee> currentEmployeesList  = <Employee>[].obs;
  RxList<Employee> previousEmployeesList = <Employee>[].obs;

  RxBool isListLoading = false.obs;

  Future<void> fetchEmployees() async {
    isListLoading.value = true;
    List<Employee> employees = await DatabaseHelper.instance.getEmployees();

      employeesList.value = employees;
    isListLoading.value = false;
  }

  Future<void> loadEmployees() async {
    isListLoading.value = true;
    List<Employee> current = await DatabaseHelper.instance.getCurrentEmployees();
    List<Employee> previous = await DatabaseHelper.instance.getPreviousEmployees();
    currentEmployeesList.value = current;
    previousEmployeesList.value = previous;
    isListLoading.value = false;
  }

  void _deleteEmployee(int id) async {
    await DatabaseHelper.instance.deleteEmployee(id);
    fetchEmployees(); // Refresh the list
  }

}