import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import '../../models/get_product.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_data.db');
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final pathToDb = join(dbPath, path);
    return await openDatabase(pathToDb, version: 1, onCreate: _createDB);
  }

  // Create tables
  Future _createDB(Database db, int version) async {
    // Create customers table
    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');

    // Create categories table
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');

    // Create products table
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price REAL
      )
    ''');
  }

  // Insert customer into database
  Future<int> insertCustomer(String name) async {
    final db = await instance.database;
    final data = {'name': name};
    return await db.insert('customers', data);
  }

  // Fetch all customers
  Future<List<String>> fetchCustomers() async {
    final db = await instance.database;
    final result = await db.query('customers');
    return result.map((e) => e['name'] as String).toList();
  }

  // Insert category into database
  Future<int> insertCategory(String name) async {
    final db = await instance.database;
    final data = {'name': name};
    return await db.insert('categories', data);
  }

  // Fetch all categories
  Future<List<String>> fetchCategories() async {
    final db = await instance.database;
    final result = await db.query('categories');
    return result.map((e) => e['name'] as String).toList();
  }

  // Insert product into database
  Future<int> insertProduct(GetProductsResult product) async {
    final db = await instance.database;
    final data = {
      'name': product.name,
      'price': product.price,
    };
    return await db.insert('products', data);
  }

  // Fetch all products
  Future<List<GetProductsResult>> fetchProducts() async {
    final db = await instance.database;
    final result = await db.query('products');

    // Map the result and cast values to the correct types.
    return result.map((e) {
      // Make sure to cast the values to the correct types (String and double)
      return GetProductsResult(
        name: e['name'] as String?,  // Cast 'name' as String?
        price: e['price'] as double?, // Cast 'price' as double?
      );
    }).toList();
  }


  // Clear customers data
  Future<void> clearCustomers() async {
    final db = await instance.database;
    await db.delete('customers');
  }
}
