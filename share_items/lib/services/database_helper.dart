import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/item.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _databaseName = 'shareitems.db';
  static Logger logger = Logger();

  static Future<Database> _getDB() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _databaseName);
    return await openDatabase(path, version: _version,
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE cars(id INTEGER PRIMARY KEY, name TEXT, supplier TEXT, details TEXT, status TEXT, type TEXT, quantity INTEGER)');
    });
  }

  // get all cars
  static Future<List<Item>> getCars() async {
    final db = await _getDB();
    final result = await db.query('cars');
    logger.log(Level.info, "getCars: $result");
    return result.map((e) => Item.fromJson(e)).toList();
  }

  // get all car that have status != "sold":
  static Future<List<Item>> getNotSoldCars() async {
    final db = await _getDB();
    final result =
        await db.query('cars', where: 'status != ?', whereArgs: ['sold']);
    logger.log(Level.info, "getNotSoldCars: $result");
    return result.map((e) => Item.fromJson(e)).toList();
  }

  // get all car that have status == "pending":
  static Future<List<Item>> getPendingCars() async {
    final db = await _getDB();
    final result =
        await db.query('cars', where: 'status = ?', whereArgs: ['pending']);
    logger.log(Level.info, "getPendingCars: $result");
    return result.map((e) => Item.fromJson(e)).toList();
  }

  // get car by id
  static Future<Item> getCarById(int id) async {
    final db = await _getDB();
    final result = await db.query('cars', where: 'id = ?', whereArgs: [id]);
    logger.log(Level.info, "getCarById: $result");
    return Item.fromJson(result[0]);
  }

  // // delete item
  // static Future<int> deleteItem(int id) async {
  //   final db = await _getDB();
  //   final result = await db.delete('items', where: 'id = ?', whereArgs: [id]);
  //   logger.log(Level.info, "deleteItem: $result");
  //   return result;
  // }

  // add item
  static Future<Item> addCar(Item item) async {
    final db = await _getDB();
    final id = await db.insert('cars', item.toJsonWithoutId(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    logger.log(Level.info, "addCar: $id");
    return item.copy(id: id);
  }

  // update price if an item *************
  static Future<int> updatePrice(int id, double price) async {
    final db = await _getDB();
    final result = await db.update('items', {'price': price},
        where: 'id = ?', whereArgs: [id]);
    logger.log(Level.info, "updatePrice: $result");
    return result;
  }
  // *********

  // update categories in database
  // static Future<void> updateCategories(List<String> categories) async {
  //   final db = await _getDB();
  //   await db.delete('categories');
  //   for (var i = 0; i < categories.length; i++) {
  //     await db.insert('categories', {'name': categories[i]});
  //   }
  //   logger.log(Level.info, "updateCategories: $categories");
  // }

  // update items in database
  static Future<void> updateCars(List<Item> items) async {
    final db = await _getDB();
    await db.delete('cars');
    for (var i = 0; i < items.length; i++) {
      await db.insert('cars', items[i].toJsonWithoutId());
    }
    logger.log(Level.info, "updateCars: $items");
  }

  // close database
  static Future<void> close() async {
    final db = await _getDB();
    await db.close();
  }
}
