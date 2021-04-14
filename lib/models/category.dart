class Category {
  int categoryId;
  String name = "";

  Category({this.categoryId, this.name});

  factory Category.fromJSON(Map<String, dynamic> json) => Category(categoryId: json['categoryId'], name: json['name']);

  @override
  String toString() {
    return 'Category{categoryId: $categoryId, name: $name}';
  }
}
