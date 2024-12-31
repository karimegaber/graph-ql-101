/*
  [variable ?? ''] => is used to save my code from getting null values
                      and crash the app. (Not recommended in all cases).
*/

class CategoryModel {
  String? id;
  String? name;
  String? description;
  String? createdAt;

  CategoryModel({this.id, this.name, this.description, this.createdAt});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    description = json['description'] ?? '';
    createdAt = json['createdAt'] ?? '';
  }
}
