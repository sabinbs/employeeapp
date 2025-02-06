import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/databasehelper.dart';
import '../modal/employee.modal.dart';
import '../widgets/customdatepicker.dart';
import '../widgets/rolebottomsheet.dart';

class AddEditEmployeeScreen extends StatefulWidget {
  final Employee? employee;

  AddEditEmployeeScreen({this.employee});

  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _roleController = TextEditingController();
  String? _selectedRole;
  String? _startDateString;
  String? _endDateString;
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate;

  // Show custom date picker
  void _selectDate(bool isStartDate) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Wrap(
        children: [
          CustomDatePicker(
            onNoDateClicked: (){
              setState(() {
                _endDate = null;
                _endDateString = 'No date';
              });
            },
            isStartDate: isStartDate,
            initialDate: isStartDate ? _startDate : _endDate,
            onDateSelected: (date) {
              setState(() {
                if (isStartDate) {
                  _startDate = date;
                  _startDateString =  DateFormat("yyyy-MM-dd").format(date);
                } else {
                  _endDate = date;
                  _endDateString =  DateFormat("yyyy-MM-dd").format(date);
                  debugPrint(date.toString());
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      // Save employee logic
      print("Employee Name: ${_nameController.text}");
      print("Designation: $_selectedRole");
      print("Start Date: ${DateFormat('yyyy-MM-dd').format(_startDate!)}");
      print(
          "End Date: ${_endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : 'No date'}");

      final employee = Employee(
        id: widget.employee?.id,
        name: _nameController.text,
        role: _roleController.text,
        startDate: DateFormat("yyyy-MM-dd").format(_startDate!),
        endDate: (_endDate == null)
            ? null:DateFormat("yyyy-MM-dd").format(_endDate!),
      );

      if (widget.employee == null) {
        await DatabaseHelper.instance.insertEmployee(employee);
      } else {
        await DatabaseHelper.instance.updateEmployee(employee);
      }

      // Close screen after saving
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _roleController = TextEditingController(text: widget.employee?.role ?? '');
    _startDateString = widget.employee?.startDate ??
        DateFormat('yyyy-MM-dd').format(_startDate!);
    _endDateString = widget.employee?.endDate ?? 'No date';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black12,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          ElevatedButton(
            onPressed: _saveEmployee,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Add Employee Details',
              style: TextStyle(color: Colors.white, fontSize: 18))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Employee Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Employee Name',
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Enter employee name' : null,
              ),
              SizedBox(height: 16),

              InkWell(
                onTap: () {
                  showRoleDialog();
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: TextFormField(
                    controller: _roleController,
                    decoration: InputDecoration(
                      labelText: 'Select Role',
                      prefixIcon: Icon(
                        Icons.work,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),

              // Role Dropdown
              /* DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: InputDecoration(
                  labelText: 'Select Role',
                  prefixIcon: Icon(Icons.work,color: Colors.blue,),
                  border: OutlineInputBorder(),
                ),
                icon: Icon(Icons.arrow_drop_down,color: Colors.blue,),
                items: _roles.map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedRole = value),
                validator: (value) => value == null ? 'Select a role' : null,
              ),*/
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: ListTile(
                        leading: Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                        ),
                        title:
                            Text(_startDateString.toString()),
                        onTap: () => _selectDate(true),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.blue,
                  ),
                  Expanded(
                    child: Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: ListTile(
                        leading: Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                        ),
                        title: Text(
                          _endDateString.toString(),
                        ),
                        onTap: () => _selectDate(false),
                      ),
                    ),
                  ),
                ],
              ),

              //Spacer(),

/*
              // Cancel & Save Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: TextStyle(color: Colors.red)),
                  ),
                  ElevatedButton(
                    onPressed: _saveEmployee,
                    child: Text('Save'),
                  ),
                ],
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  void showRoleDialog() {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return RoleBottomSheet(
          onCategorySelected: (String selectedCategory) {
            setState(() {
              _roleController.text = selectedCategory;
              _selectedRole = selectedCategory;
            });
          },
          onClose: () {
            // _reportNode.nextFocus();
          },
        );
      },
    );
  }
}
