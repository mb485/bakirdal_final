import 'dart:async';
import 'dart:io';

import 'package:bakirdal_final/models/product.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;
  static Database _database;


  String _cartTableName = "cart";
  String _columnId = "id";
  String _columnCategoryId = "categoryId";
  String _columnName = "name";
  String _columnPrice = "price";
  String _columnImg = "img";

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await initDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> initDatabase() async {
    Directory folder =  await getApplicationDocumentsDirectory();
    String cartDBPath = join(folder.path, 'cart.db');

    Database cartDb = await openDatabase(cartDBPath,version: 1,onCreate: _createDB);
    return cartDb;
  }

  FutureOr<void> _createDB(Database db, int version) async{
    await db.execute(
        "CREATE TABLE $_cartTableName ($_columnId INTEGER PRIMARY KEY, $_columnCategoryId INTEGER, $_columnName TEXT,$_columnPrice TEXT,$_columnImg TEXT )"
    );
  }

  Future<int> addProduct(Product product) async{
    Database db = await _getDatabase();
    int result = await db.insert(_cartTableName, product.toJson(),nullColumnHack: "$_columnId");
    return result;
  }

  Future<List<Map<String,dynamic>>> getCartProduct()async{
    Database db = await _getDatabase();
    List<Map<String,dynamic>> allProducts = await db.query(_cartTableName, orderBy: "$_columnPrice DESC");
    return allProducts;
  }


  Future<int> deleteProductFromCart(int id) async {
    Database db = await _getDatabase();
    return await db.delete(_cartTableName,where: "$_columnId = ?",whereArgs: [id]);
  }


}
