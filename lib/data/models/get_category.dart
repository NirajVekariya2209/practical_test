class GetCategoryResponse {
  List<String>? getCategoriesResult;

  GetCategoryResponse({this.getCategoriesResult});

  GetCategoryResponse.fromJson(Map<String, dynamic> json) {
    getCategoriesResult = json['GetCategoriesResult'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GetCategoriesResult'] = this.getCategoriesResult;
    return data;
  }
}
