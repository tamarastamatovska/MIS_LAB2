class Meal{
  String idMeal;
  String strMeal;
  String strMealThumb;
  String? strCategory;

  Meal(
  {
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    this.strCategory,
}
);

  factory Meal.fromJson(Map<String,dynamic> json){
    return Meal(
      idMeal: json['idMeal'] ?? '',
      strMeal: json['strMeal'] ?? '',
      strMealThumb: json['strMealThumb'] ?? '',
      strCategory: json['strCategory'],
    );
  }
}