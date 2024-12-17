class GetProductResponse {
  List<GetProductsResult>? getProductsResult;

  GetProductResponse({this.getProductsResult});

  GetProductResponse.fromJson(Map<String, dynamic> json) {
    if (json['GetProductsResult'] != null) {
      getProductsResult = <GetProductsResult>[];
      json['GetProductsResult'].forEach((v) {
        getProductsResult!.add(new GetProductsResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.getProductsResult != null) {
      data['GetProductsResult'] =
          this.getProductsResult!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetProductsResult {
  String? name;
  double? price;

  GetProductsResult(
      {
        this.name,
        this.price,
});

  GetProductsResult.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    price = json['Price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Price'] = this.price;
    return data;
  }
}
