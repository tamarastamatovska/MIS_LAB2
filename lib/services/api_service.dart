import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/meal_model.dart';
import '../models/meal_detail_model.dart';


class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1' ;

  Future<List<Category>> loadCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories.php'),
      );

      if (response.statusCode == 200)
        {
          final data = json.decode(response.body);
          List<Category> categories = [];

          if(data['categories'] != null){
            final categories2 = data['categories'] as List;
            for(var category in categories2){
              categories.add(Category.fromJson(category));
            }
          }
          return categories;
        }
      return [];
    }
    catch(e){
      print("Error loading categories: $e");
      return [];
    }
  }

  Future<List<Meal>> loadMealsByCategory(String category) async {
    try{
      final response = await http.get(
        Uri.parse('$baseUrl/filter.php?c=$category'),
      );

      if(response.statusCode ==200)
        {
          final data = json.decode(response.body);

          List<Meal> meals = [];

          if(data['meals'] != null){
            final meals2 = data['meals'] as List;
            for(var meal in meals2){
              meals.add(Meal.fromJson(meal));
            }
          }
          return meals;
        }
      return [];

    }
    catch(e){
      print('Error loading meals: $e');
      return [];
    }
  }

  Future<MealDetail?> getMealDetail(String id) async {
    try{
      final response = await http.get(
        Uri.parse('$baseUrl/lookup.php?i=$id'),
      );

      if(response.statusCode == 200){
        final data = json.decode(response.body);

        if(data!= null && data['meals']!=null && (data['meals'] as List).isNotEmpty){
          return MealDetail.fromJson(data['meals'][0]);
        }
      }
    return null;

    }
    catch(e){
      print('Error loading meal detail: $e');
      return null;
    }
  }


  Future<MealDetail?> getRandomMeal() async {
    try{
      final response = await http.get(
        Uri.parse('$baseUrl/random.php'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data['meals'] != null && (data['meals'] as List).isNotEmpty) {
          return MealDetail.fromJson(data['meals'][0]);
        }
      }
      return null;
    }
    catch (e) {
      print('Error loading random meal: $e');
      return null;
    }
  }

  Future<List<Meal>> searchMeals(String query) async{
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search.php?s=$query'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Meal> meals = [];

        if (data != null && data['meals'] != null) {
          final meals2 = data['meals'] as List;
          for (var meal in meals2) {
            meals.add(Meal.fromJson(meal));
          }
        }

        return meals;
      }
      return [];
    } catch (e) {
      print('Error searching meals: $e');
      return [];
    }
  }


}