import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../models/item.dart';

const String baseUrl = 'http://192.168.197.1:2406';

class ApiService {
  static final ApiService instance = ApiService._init();
  static final Dio dio = Dio();
  var logger = Logger();

  ApiService._init();

  Future<List<Item>> getCars() async {
    logger.log(Level.info, 'getCars');
    final response = await dio.get('$baseUrl/cars');
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      final result = response.data as List;
      return result.map((e) => Item.fromJson(e)).toList();
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<List<Item>> getNotSoldCars() async {
    logger.log(Level.info, 'getNotSoldCars');
    final response = await dio.get('$baseUrl/carstypes');
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      final result = response.data as List;
      return result.map((e) => Item.fromJson(e)).toList();
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<List<Item>> getPendingCars() async {
    logger.log(Level.info, 'getPendingCars');
    final response = await dio.get('$baseUrl/carorders');
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      final result = response.data as List;
      return result.map((e) => Item.fromJson(e)).toList();
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<Item> getCarById(int id) async {
    logger.log(Level.info, 'getCarById: $id');
    final response = await dio.get('$baseUrl/car/$id');
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      return Item.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  // Future<List<Item>> getDiscountedItems() async {
  //   logger.log(Level.info, 'getDiscountedItems');
  //   final response = await dio.get('$baseUrl/discounted');
  //   logger.log(Level.info, response.data);
  //   if (response.statusCode == 200) {
  //     final result = response.data as List;
  //     var items = result.map((e) => Item.fromJson(e)).toList();
  //     // return top 10 items sorted ascending by price and number of units
  //     items.sort((a, b) {
  //       int first = a.type.compareTo(b.type);
  //       if (first == 0) {
  //         return a.quantity.compareTo(b.quantity);
  //       } else {
  //         return first;
  //       }
  //     });
  //     return items.sublist(0, 10);
  //   } else {
  //     throw Exception(response.statusMessage);
  //   }
  // }

  Future<Item> addCar(Item item) async {
    logger.log(Level.info, 'addCar: $item');
    final response =
        await dio.post('$baseUrl/car', data: item.toJsonWithoutId());
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      return Item.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  // void deleteItem(int id) async {
  //   logger.log(Level.info, 'deleteItem: $id');
  //   final response = await dio.delete('$baseUrl/item/$id');
  //   logger.log(Level.info, response.data);
  //   if (response.statusCode != 200) {
  //     throw Exception(response.statusMessage);
  //   }
  // }

  // void updatePrice(int id, double price) async {
  //   logger.log(Level.info, 'updatePrice: $id, $price');
  //   final response =
  //       await dio.post('$baseUrl/price', data: {'id': id, 'price': price});
  //   logger.log(Level.info, response.data);
  //   if (response.statusCode != 200) {
  //     throw Exception(response.statusMessage);
  //   }

  // request a car
}
