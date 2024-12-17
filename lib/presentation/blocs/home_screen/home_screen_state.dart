import 'package:practical_test/data/models/get_category.dart';
import 'package:practical_test/data/models/get_cutomer.dart';
import 'package:practical_test/data/models/get_product.dart';

abstract class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState {}

class HomeScreenLoading extends HomeScreenState {}

class HomeScreenCustomerLoaded extends HomeScreenState {
  final GetCustomerResponse customers;
  HomeScreenCustomerLoaded(this.customers);
}

class HomeScreenCategoryLoaded extends HomeScreenState {
  final GetCategoryResponse category;
  HomeScreenCategoryLoaded(this.category);
}

class HomeScreenProductLoaded extends HomeScreenState {
  final GetProductResponse product;
  HomeScreenProductLoaded(this.product);
}

class HomeScreenError extends HomeScreenState {
  final String message;
  HomeScreenError(this.message);
}
