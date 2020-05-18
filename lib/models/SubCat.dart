
class SubCategories {
  int id;
  String name;
  int categoryID;
  String description;

  SubCategories({this.id, this.name, this.categoryID, this.description});

  SubCategories.fromJson(Map<String, dynamic> json) {
 json['id'];
    name = json['name'];
    categoryID = json['categoryID'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['categoryID'] = this.categoryID;
    data['description'] = this.description;
    return data;
  }
}