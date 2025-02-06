import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../modal/employee.modal.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'employee.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE employees (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            role TEXT NOT NULL,
            start_date TEXT NOT NULL,
            end_date TEXT
          )
        ''');
      },
    );
  }

  // Insert Employee
  Future<int> insertEmployee(Employee employee) async {
    Database db = await database;
    return await db.insert('employees', employee.toMap());
  }

  // Fetch all Employees
  Future<List<Employee>> getEmployees() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('employees');
    return maps.map((e) => Employee.fromMap(e)).toList();
  }

  // Fetch current employees (where end_date is NULL or empty)
  Future<List<Employee>> getCurrentEmployees() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'employees',
      where: "end_date IS NULL OR end_date = 'No date'",
    );
    return maps.map((e) => Employee.fromMap(e)).toList();
  }

  // Fetch previous employees (where end_date is NOT NULL)
  Future<List<Employee>> getPreviousEmployees() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'employees',
      where: "end_date IS NOT NULL AND end_date != 'No date'",
    );
    return maps.map((e) => Employee.fromMap(e)).toList();
  }

  // Update Employee
  Future<int> updateEmployee(Employee employee) async {
    Database db = await database;
    return await db.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  // Delete Employee
  Future<int> deleteEmployee(int id) async {
    Database db = await database;
    return await db.delete('employees', where: 'id = ?', whereArgs: [id]);
  }
}
