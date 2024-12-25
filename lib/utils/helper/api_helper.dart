import 'package:dio/dio.dart';

class ApiHelper {
  ApiHelper._();
  static ApiHelper apiHelper = ApiHelper._();

  Dio dio = Dio();

  Future<List> fetchAllCategorieList() async {
    Response response =
        await dio.get('https://dummyjson.com/products/category-list');

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<List> getProductsByCategory(String category) async {
    Response response =
        await dio.get('https://dummyjson.com/products/category/$category');
    if (response.statusCode == 200) {
      Map<String, dynamic> rowData = response.data;
      List data = rowData['products'];
      return data;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<List> getAllProducts() async {
    Response response = await dio.get('https://dummyjson.com/products');
    if (response.statusCode == 200) {
      Map<String, dynamic> rowData = response.data;
      List? data = rowData['products'];
      return data ?? [];
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<List> searchProducts(String searchText) async {
    Response response =
        await dio.get('https://dummyjson.com/products/search?q=$searchText');
    if (response.statusCode == 200) {
      Map<String, dynamic> rowData = response.data;
      List data = rowData['products'];
      return data;
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
