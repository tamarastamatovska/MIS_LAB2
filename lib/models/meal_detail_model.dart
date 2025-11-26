class MealDetail{
  String idMeal;
  String strMeal;
  String strCategory;
  String strArea;
  String strInstructions;
  String strMealThumb;
  String? strYoutube;
  List<String> ingredients;
  List<String> measures;

  MealDetail({
    required this.idMeal,
    required this.strMeal,
    required this.strCategory,
    required this.strArea,
    required this.strInstructions,
    required this.strMealThumb,
    this.strYoutube,
    required this.ingredients,
    required this.measures,
  });

  factory MealDetail.fromJson(Map<String,dynamic> data){
    List<String> ingredients = [];
    List<String> measures = [];

    for(int i=1;i<=20;i++)
      {
        String? ingredient = data['strIngredient$i'];
        String? measure = data['strMeasure$i'];

        if(ingredient != null && ingredient.isNotEmpty){
          ingredients.add(ingredient);
          measures.add(measure ?? '');
        }
      }

    return MealDetail(
      idMeal: data['idMeal'] ?? '',
      strMeal: data['strMeal'] ?? '',
      strCategory: data['strCategory'] ?? '',
      strArea: data['strArea'] ?? '',
      strInstructions: data['strInstructions'] ?? '',
      strMealThumb: data['strMealThumb'] ?? '',
      strYoutube: data['strYoutube'],
      ingredients: ingredients,
      measures: measures
    );
  }
}