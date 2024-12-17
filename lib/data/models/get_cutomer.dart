class GetCustomerResponse {
  List<GetCustomersResult>? getCustomersResult;

  GetCustomerResponse({this.getCustomersResult});

  GetCustomerResponse.fromJson(Map<String, dynamic> json) {
    if (json['GetCustomersResult'] != null) {
      getCustomersResult = <GetCustomersResult>[];
      json['GetCustomersResult'].forEach((v) {
        getCustomersResult!.add(new GetCustomersResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.getCustomersResult != null) {
      data['GetCustomersResult'] =
          this.getCustomersResult!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetCustomersResult {
  String? name;

  GetCustomersResult(
      {
        this.name,
       });

  GetCustomersResult.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    return data;
  }
}
