import 'dart:io';
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
// db.execute(
    //     "CREATE TABLE purchase_items(p_item_id	INTEGER PRIMARY KEY AUTOINCREMENT, vendor_id INTEGER, product_id	INTEGER, p_item_price	TEXT, p_item_qty	TEXT, p_item_total_price	TEXT)");
    // db.execute(
    //     "CREATE TABLE sell_items(sell_item_id	INTEGER PRIMARY KEY AUTOINCREMENT, sell_item_name	TEXT, sell_item_price	TEXT, sell_item_qty	TEXT, sell_item_total_price	TEXT)");
    db.execute(
        "CREATE TABLE groups(group_id INTEGER PRIMARY KEY AUTOINCREMENT, group_name TEXT)");
    db.execute(
        "CREATE TABLE ledgers(ledger_id	INTEGER PRIMARY KEY AUTOINCREMENT, group_id	INTEGER, ledger_name TEXT, ledger_mobile	TEXT, ledger_type	TEXT)");
    db.execute(
        "CREATE TABLE products(product_id INTEGER PRIMARY KEY AUTOINCREMENT, product_name TEXT, product_price TEXT, product_qty TEXT)");
    db.execute(
        "CREATE TABLE purchase(purchase_id	INTEGER PRIMARY KEY AUTOINCREMENT, ledger_id	INTEGER, product_id INTEGER, stock_t_id	INTEGER, purchase_date TEXT, purchase_total	TEXT, purchase_gst	TEXT, purchase_grand_total	TEXT)");
    db.execute(
        "CREATE TABLE p_return(p_return__id	INTEGER PRIMARY KEY AUTOINCREMENT, ledger_id	INTEGER, product_id INTEGER, stock_t_id	INTEGER, p_return_reason TEXT, p_return_date TEXT, p_return_qty TEXT)");
    db.execute(
        "CREATE TABLE sell(sell_id	INTEGER PRIMARY KEY AUTOINCREMENT, ledger_id	INTEGER, product_id INTEGER, stock_t_id	INTEGER, sell_date TEXT, sell_total	TEXT, sell_gst	TEXT, sell_grand_total	TEXT)");
    db.execute(
        "CREATE TABLE s_return(s_return__id	INTEGER PRIMARY KEY AUTOINCREMENT, ledger_id	INTEGER, product_id INTEGER, stock_t_id	INTEGER, s_return_reason TEXT, s_return_date TEXT, s_return_qty TEXT)");
    db.execute(
        "CREATE TABLE stock_transaction(stock_id	INTEGER PRIMARY KEY AUTOINCREMENT, ledger_id	INTEGER, product_id	INTEGER, voucher_number	INTEGER, voucher_type	TEXT, stock_dateTime TEXT, stock_in	TEXT, stock_out	TEXT, total_stock TEXT)");

    db.rawInsert("INSERT INTO groups(group_name) VALUES('vendor')");
    db.rawInsert("INSERT INTO groups(group_name) VALUES('customer')");
  }

  Future<int> addLedger(String ledger_name, int group_id, String ledger_mobile,
      String ledger_type) async {
    //TODO: RAW INSERT QUERY
    Database db = await instance.database;
    return db.rawInsert(
        "INSERT INTO ledgers(ledger_name, group_id, ledger_mobile, ledger_type) VALUES('$ledger_name', $group_id, '$ledger_mobile', '$ledger_type')");
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

  Future<void> addToPurchase(
      int _ledgerId,
      int _productId,
      String _purchaseDate,
      String _purchaseTotal,
      String _gst,
      String _grandTotal,
      String _stockIn) async {
    //TODO: RAW INSERT QUERY
    Database db = await instance.database;
    db
        .rawInsert(
            "INSERT INTO purchase(ledger_id, product_id, purchase_date, purchase_total, purchase_gst, purchase_grand_total) VALUES('$_ledgerId', '$_productId', '$_purchaseDate', '$_purchaseTotal', '$_gst', '$_grandTotal')")
        .then((value) {
      db
          .rawQuery("select last_insert_rowid() FROM purchase")
          .then((_purchaseId) {
        stockTransaction(_ledgerId, _purchaseId[0]['last_insert_rowid()'],
                _productId, "purchase", _purchaseDate, _stockIn, "0")
            .then((_stockTId) {
          db.rawUpdate(
              "UPDATE purchase SET stock_t_id = '${_stockTId[0]['last_insert_rowid()']}' WHERE purchase_id = '${_purchaseId[0]['last_insert_rowid()']}'");
          db
              .rawQuery(
                  "SELECT product_qty FROM products WHERE product_id = $_productId")
              .then((_productQty) {
            print(_productQty[0]['product_qty']);
            double qtyTemp = double.parse(_productQty[0]['product_qty']);
            qtyTemp += double.parse(_stockIn);
            print(qtyTemp.toString());
            String qty = qtyTemp.round().toString();
            db.rawUpdate(
                "UPDATE products SET product_qty = '$qty' WHERE product_id = '$_productId'");
          });
        });
      });
    });
  }

  Future<void> purchaseReturn(int _ledgerId, int _productId, String _pReturnReason, String _pReturnDate, String _pReturnQty) async {
    Database db = await instance.database;
    db.rawInsert(
        "INSERT INTO p_return(ledger_id, product_id, p_return_reason, p_return_date, p_return_qty) VALUES('$_ledgerId', '$_productId', '$_pReturnReason', '$_pReturnDate', '$_pReturnQty')").then((value){
          db.rawQuery("select last_insert_rowid() FROM p_return").then((_pReturnId) {
            stockTransaction(_ledgerId, _pReturnId[0]['last_insert_rowid()'], _productId, "p_return", _pReturnDate, "0", _pReturnQty).then((_stockTId) {
              db.rawUpdate(
                  "UPDATE p_return SET stock_t_id = '${_stockTId[0]['last_insert_rowid()']}' WHERE p_return__id = '${_pReturnId[0]['last_insert_rowid()']}'");
              db.rawQuery(
                  "SELECT product_qty FROM products WHERE product_id = $_productId").then((_productQty) {
                print(_productQty[0]['product_qty']);
                double qtyTemp = double.parse(_productQty[0]['product_qty']);
                qtyTemp -= double.parse(_pReturnQty);
                print(qtyTemp.round().toString());
                String qty = qtyTemp.round().toString();
                db.rawUpdate(
                    "UPDATE products SET product_qty = '$qty' WHERE product_id = '$_productId'");
              });
            });
          });
    });
  }

  Future<void> saleReturn(int _ledgerId, int _productId, String _sReturnReason, String _sReturnDate, String _sReturnQty) async {
    Database db = await instance.database;
    db.rawInsert(
        "INSERT INTO s_return(ledger_id, product_id, s_return_reason, s_return_date, s_return_qty) VALUES('$_ledgerId', '$_productId', '$_sReturnReason', '$_sReturnDate', '$_sReturnQty')").then((value){
          db.rawQuery("select last_insert_rowid() FROM s_return").then((_sReturnId) {
            stockTransaction(_ledgerId, _sReturnId[0]['last_insert_rowid()'], _productId, "s_return", _sReturnDate, _sReturnQty, "0").then((_stockTId) {
              db.rawUpdate(
                  "UPDATE s_return SET stock_t_id = '${_stockTId[0]['last_insert_rowid()']}' WHERE s_return__id = '${_sReturnId[0]['last_insert_rowid()']}'");
              db.rawQuery(
                  "SELECT product_qty FROM products WHERE product_id = $_productId").then((_productQty) {
                print(_productQty[0]['product_qty']);
                double qtyTemp = double.parse(_productQty[0]['product_qty']);
                qtyTemp += double.parse(_sReturnQty);
                print(qtyTemp.round().toString());
                String qty = qtyTemp.round().toString();
                db.rawUpdate(
                    "UPDATE products SET product_qty = '$qty' WHERE product_id = '$_productId'");
              });
            });
          });
    });
  }

  Future<void> addToSell(
      int _ledgerId,
      int _productId,
      String _sellDate,
      String _sellTotal,
      String _sellGst,
      String _grandTotal,
      String _stockOut) async {
    //TODO: RAW INSERT QUERY
    Database db = await instance.database;
    // db.rawInsert(
    //     "INSERT INTO purchase_items(vendor_id, product_id, p_item_price, p_item_qty) VALUES('$vendorId', '$p_id', '$p_price', '$p_qty')");
    db
        .rawInsert(
            "INSERT INTO sell(ledger_id, product_id, sell_date, sell_total, sell_gst, sell_grand_total) VALUES('$_ledgerId', '$_productId', '$_sellDate', '$_sellTotal', '$_sellGst', '$_grandTotal')")
        .then((value) {
      db.rawQuery("select last_insert_rowid() FROM sell").then((_sellId) {
        stockTransaction(_ledgerId, _sellId[0]['last_insert_rowid()'],
                _productId, "Sell", _sellDate, "0", _stockOut)
            .then((_stockTId) {
          db.rawUpdate(
              "UPDATE sell SET stock_t_id = '${_stockTId[0]['last_insert_rowid()']}' WHERE sell_id = '${_sellId[0]['last_insert_rowid()']}'");
          db
              .rawQuery(
                  "SELECT product_qty FROM products WHERE product_id = $_productId")
              .then((_productQty) {
            print(_productQty[0]['product_qty']);
            double qtyTemp = double.parse(_productQty[0]['product_qty']);
            qtyTemp -= double.parse(_stockOut);
            print(qtyTemp.toString());
            String qty = qtyTemp.round().toString();
            db.rawUpdate(
                "UPDATE products SET product_qty = '$qty' WHERE product_id = '$_productId'");
          });
        });
      });
    });
  }

  Future<List> stockTransaction(
      int _ledgerId,
      int _voucherNo,
      int _productId,
      String _voucherType,
      String _dateTime,
      String _stockIn,
      String _stockOut) async {
    Database db = await instance.database;
    db.rawInsert(
        "INSERT INTO stock_transaction(ledger_id, voucher_number, product_id, voucher_type, stock_dateTime, stock_in, stock_out) VALUES('$_ledgerId', '$_voucherNo', '$_productId', '$_voucherType', '$_dateTime', '$_stockIn', '$_stockOut')");
    return db.rawQuery("select last_insert_rowid() FROM stock_transaction");
  }

  Future<int> getCount(String tableName) async {
    Database db = await instance.database;
    var x;
    if (tableName == "ledgersV") {
      x = await db
          .rawQuery('SELECT COUNT (*) from ledgers WHERE ledger_type = 1');
    } else if (tableName == "ledgersC") {
      x = await db
          .rawQuery('SELECT COUNT (*) from ledgers WHERE ledger_type = 2');
    } else if (tableName == "products") {
      x = await db.rawQuery('SELECT COUNT (*) from products');
    } else {
      x = await db.rawQuery('SELECT COUNT (*) from $tableName');
    }
    int count = Sqflite.firstIntValue(x);
    return count;
  }

  Future<List> getTable(String tableName) async {
    Database db = await instance.database;
    return db.rawQuery("SELECT * FROM $tableName");
  }

  Future<List> getLedgers(String _ledgerType) async {
    Database db = await instance.database;
    return db
        .rawQuery("SELECT * FROM ledgers WHERE ledger_type = $_ledgerType");
  }

  Future<List> getProducts() async {
    Database db = await instance.database;
    return db.rawQuery("SELECT * FROM products");
  }

  Future<void> deleteProduct(int productId) async {
    Database db = await instance.database;
    db.rawDelete("DELETE FROM products WHERE product_id=$productId");
  }
} //class DatabaseHelper close
