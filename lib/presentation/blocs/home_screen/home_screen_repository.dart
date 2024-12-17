import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../data/models/get_category.dart';
import '../../../data/models/get_cutomer.dart';
import '../../../data/models/get_product.dart';

class HomeScreenRepository {
  final String customerBaseUrl = 'https://foodmanandws.isni.co/AndroidService.svc/GetCustomers';
  final String categoryBaseUrl = 'https://foodmanandws.isni.co/AndroidService.svc/GetCategories';
  final String productBaseUrl = 'https://foodmanandws.isni.co/AndroidService.svc/GetProducts';

  Future<GetCustomerResponse> fetchCustomers(Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse(customerBaseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return GetCustomerResponse.fromJson(responseBody);
    } else {
      throw Exception('Failed to fetch customers: ${response.statusCode}');
    }
  }

  Future<GetCategoryResponse> fetchCategory(Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse(categoryBaseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return GetCategoryResponse.fromJson(responseBody);
    } else {
      throw Exception('Failed to fetch customers: ${response.statusCode}');
    }
  }

  Future<GetProductResponse> fetchProduct(Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse(productBaseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return GetProductResponse.fromJson(responseBody);
    } else {
      throw Exception('Failed to fetch customers: ${response.statusCode}');
    }
  }
}
