import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
    if (kIsWeb) {
      // Use Web Database
      return await databaseFactoryFfiWeb.openDatabase(
        'employee.db',
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
            CREATE TABLE IF NOT EXISTS employees (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              role TEXT NOT NULL,
              start_date TEXT NOT NULL,
              end_date TEXT
            )
          ''');
          },
        ),
      );
    } else if (Platform.isAndroid || Platform.isIOS) {
      String path = join(await getDatabasesPath(), 'employee.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS employees (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              role TEXT NOT NULL,
              start_date TEXT NOT NULL,
              end_date TEXT
            )
          ''');
        },
      );
    } else {
      databaseFactory = databaseFactoryFfi;
      String path = await _getDatabasePath('employee.db');
      return await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE IF NOT EXISTS employees (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                role TEXT NOT NULL,
                start_date TEXT NOT NULL,
                end_date TEXT
              )
            ''');
          },
        ),
      );
    }
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

  Future<String> _getDatabasePath(String dbName) async {
    if (Platform.isAndroid || Platform.isIOS) {
      var databasesPath = await getDatabasesPath();
      return join(databasesPath, dbName);
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return join(directory.path, dbName);
    }
  }

  // CRUD Operations
  Future<int> insertEmployee(Employee employee) async {
    Database db = await database;
    return await db.insert('employees', employee.toMap());
  }

  Future<List<Employee>> getEmployees() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('employees');
    return maps.map((e) => Employee.fromMap(e)).toList();
  }

  Future<int> updateEmployee(Employee employee) async {
    Database db = await database;
    return await db.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<int> deleteEmployee(int id) async {
    Database db = await database;
    return await db.delete('employees', where: 'id = ?', whereArgs: [id]);
  }
}
