import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  //TODO: PASS "DATABASE_NAME.db"
  String _databaseName = "stock.db";
  int _databaseVersion = 1;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

// only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) {
    //TODO: CREATE TABLE QUERY
    // db.execute(
    //     "CREATE TABLE customer(customer_id INTEGER PRIMARY KEY AUTOINCREMENT, customer_name TEXT, customer_mobile TEXT, customer_balance TEXT)");
    // db.execute(
    //     "CREATE TABLE vendor(vendor_id INTEGER PRIMARY KEY AUTOINCREMENT, vendor_name TEXT, vendor_mobile TEXT)");
    // db.execute(
    //     "CREATE TABLE item(item_id INTEGER PRIMARY KEY AUTOINCREMENT, item_name TEXT, item_price TEXT, item_qty TEXT)");

    db.execute(
        "CREATE TABLE group(group_id INTEGER PRIMARY KEY AUTOINCREMENT, group_name TEXT)");
    db.execute(
        "CREATE TABLE ledgers(ledger_id	INTEGER PRIMARY KEY AUTOINCREMENT, group_id	INTEGER, ledger_name TEXT, ledger_mobile	TEXT, ledger_type	TEXT)");
    db.execute(
        "CREATE TABLE products(product_id INTEGER PRIMARY KEY AUTOINCREMENT, product_name TEXT, product_price TEXT, product_qty TEXT)");
    db.execute(
        "CREATE TABLE purchase(purchase_id	INTEGER PRIMARY KEY AUTOINCREMENT, ledger_id	INTEGER, stock_t_id	INTEGER, purchase_total	TEXT, purchase_gst	TEXT, purchase_grand_total	TEXT)");
    db.execute(
        "CREATE TABLE purchase_items(p_item_id	INTEGER PRIMARY KEY AUTOINCREMENT, vendor_id INTEGER, product_id	INTEGER, p_item_price	TEXT, p_item_qty	TEXT, p_item_total_price	TEXT)");
    db.execute(
        "CREATE TABLE sell(sell_id	INTEGER PRIMARY KEY AUTOINCREMENT, ledger_id	INTEGER, stock_t_id	INTEGER, sell_total	TEXT, sell_gst	TEXT, sell_grand_total	TEXT)");
    db.execute(
        "CREATE TABLE sell_items(sell_item_id	INTEGER PRIMARY KEY AUTOINCREMENT, sell_item_name	TEXT, sell_item_price	TEXT, sell_item_qty	TEXT, sell_item_total_price	TEXT)");
    db.execute(
        "CREATE TABLE stock_transaction(stock_id	INTEGER PRIMARY KEY AUTOINCREMENT, ledger_id	INTEGER, product_id	INTEGER, voucher_type	TEXT, voucher_number	INTEGER, stock_in	TEXT, stock_out	TEXT)");
  }

  Future<int> addLedger(String ledger_name, String ledger_mobile,
      String ledger_type) async {
    //TODO: RAW INSERT QUERY
    Database db = await instance.database;
    return db.rawInsert(
        "INSERT INTO ledgers(ledger_name, ledger_mobile, ledger_type) VALUES('$ledger_name', '$ledger_mobile', '$ledger_type')");
  }

  // Future<int> addVendor(String vendor_name, String vendor_mobile) async {
  //   //TODO: RAW INSERT QUERY
  //   Database db = await instance.database;
  //   return db.rawInsert(
  //       "INSERT INTO vendor(vendor_name, vendor_mobile) VALUES('$vendor_name', '$vendor_mobile')");
  // }

  Future<int> addProducts(
      String product_name, String product_price, String product_qty) async {
    //TODO: RAW INSERT QUERY
    Database db = await instance.database;
    return db.rawInsert(
        "INSERT INTO products(product_name, product_price, product_qty) VALUES('$product_name', '$product_price', '$product_qty')");
  }

  Future<int> purchaseProduct(
      int vendorId, int p_id, String p_price, String p_qty) async {
    //TODO: RAW INSERT QUERY
    Database db = await instance.database;
    return db.rawInsert(
        "INSERT INTO purchase_items(vendor_id, product_id, p_item_price, p_item_qty) VALUES('$vendorId', '$p_id', '$p_price', '$p_qty')");
  }

  Future<int> getCount(String tableName) async {
    Database db = await instance.database;
    var x; 
    if(tableName == "ledgersV"){
    x = await db.rawQuery('SELECT COUNT (*) from ledgers WHERE ledger_type = 1');
    }else if(tableName == "ledgersC"){
      x = await db.rawQuery('SELECT COUNT (*) from ledgers WHERE ledger_type = 2');
    }else if(tableName == "products"){
      x = await db.rawQuery('SELECT COUNT (*) from products');
    }else if(tableName == "purchase"){
      x = await db.rawQuery('SELECT COUNT (*) from purchase_items');
    }
    int count = Sqflite.firstIntValue(x);
    return count;
  }

  Future<List> getTable(String tableName) async{
    Database db = await instance.database;
    return db.rawQuery("SELECT * FROM $tableName");
  }

  Future<List> getLedgers(String _ledgerType) async {
    Database db = await instance.database;
    return db.rawQuery("SELECT * FROM ledgers WHERE ledger_type = $_ledgerType");
  }

  Future<List> getProducts() async {
    Database db = await instance.database;
    return db.rawQuery("SELECT * FROM products");
  }

  Future<void> deleteUser() async {
    Database db = await instance.database;
    db.rawDelete("DELETE FROM user");
  }
} //class DatabaseHelper close
