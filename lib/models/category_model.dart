class Category {
  String idCategory;
  String strCategory;
  String strCategoryThumb;
  String strCategoryDescription;

  Category({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
    required this.strCategoryDescription
});

  factory Category.fromJson(Map<String,dynamic> data)
  {
    return Category(
        idCategory: data['idCategory'] ?? '',
        strCategory: data['strCategory'] ?? '',
        strCategoryThumb: data['strCategoryThumb'] ?? '',
        strCategoryDescription: data['strCategoryDescription'] ?? ''
    );
  }
}