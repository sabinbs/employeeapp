import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/employ.list.controller.dart';
import '../database/databasehelper.dart';
import '../modal/employee.modal.dart';
import 'add_edit_employee_screen.dart';


class EmployeeListScreen extends StatefulWidget {
  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {


  final EmployeeListController employeeListController =
  Get.put(EmployeeListController());

  @override
  void initState() {
    super.initState();
    employeeListController.loadEmployees();
  }



  void _navigateToAddEdit(Employee? employee) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditEmployeeScreen(employee: employee)),
    );
    employeeListController.loadEmployees();// Refresh after returning
  }

  // Delete an employee
  void _deleteEmployee(int id) async {
    await DatabaseHelper.instance.deleteEmployee(id);
    var snackBar = SnackBar(content: Text('Employee data has been deleted.'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    employeeListController.loadEmployees();// Refresh the list
  }

  // Employee list item UI
  Widget _buildEmployeeTile(Employee employee) {
    return Dismissible(
      key: Key(employee.id.toString()),
      background:  Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              Text(
                " Delete",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
      ),
      onDismissed: (direction) => _deleteEmployee(employee.id!),
      child: ListTile(
        title: Text(employee.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(employee.role),
            Text(
              employee.endDate == null || employee.endDate!.isEmpty || employee.endDate.toString() == "No date"
                  ? "From ${employee.startDate}"
                  : "${employee.startDate} - ${employee.endDate}",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        onTap: () => _navigateToAddEdit(employee),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Employee List',style: TextStyle(color: Colors.white,fontSize: 18))),
      body:Obx(()=> employeeListController.isListLoading.value? SizedBox(
          height: MediaQuery.sizeOf(context).height - 100,
          child: const Center(
            child: CircularProgressIndicator(),
          ))
          : employeeListController.currentEmployeesList.isEmpty&&employeeListController.previousEmployeesList.isEmpty?SizedBox(
          height: MediaQuery.sizeOf(context).height - 150,
          child:  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        width: 300,
                        height: 300,
                        child: Image.asset('assets/images/dummy.png')),
                  ),
                  Text("No employess record Found"),
                ],
              )
          )):ListView(
                  children: [
          // Section for current employees
          if (employeeListController.currentEmployeesList.isNotEmpty) ...[

            Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              color: Colors.grey.shade300,
              child:Text("Current employees", style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold)),

            ),



            Divider(
              height: 0,
              color: Colors.grey[300],
              indent: 0,
              thickness: 1,
            ),
            ...employeeListController.currentEmployeesList.map(_buildEmployeeTile).toList(),
          ],
                    employeeListController.currentEmployeesList.isNotEmpty?SizedBox(height: 20):SizedBox(height: 0),
          // Section for previous employees
          if (employeeListController.previousEmployeesList.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              color: Colors.grey.shade300,
              child:Text("Previous employees", style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold)),

            ),
            Divider(
              height: 0,
              color: Colors.grey[300],
              indent: 0,
              thickness: 1,
            ),
            ...employeeListController.previousEmployeesList.map(_buildEmployeeTile).toList(),
          ],
                  ],
                ),),



      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => _navigateToAddEdit(null),
        child: Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
