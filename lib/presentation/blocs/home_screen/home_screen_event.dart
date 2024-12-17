abstract class HomeScreenEvent {}

class FetchCustomerEvent extends HomeScreenEvent {
  final Map<String, dynamic> requestBody;

  FetchCustomerEvent(this.requestBody);
}

class FetchCategoryEvent extends HomeScreenEvent {
  final Map<String, dynamic> requestBody;

  FetchCategoryEvent(this.requestBody);
}

class FetchProductEvent extends HomeScreenEvent {
  final Map<String, dynamic> requestBody;

  FetchProductEvent(this.requestBody);
}