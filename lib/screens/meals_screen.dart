import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../services/api_service.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class MealsScreen extends StatefulWidget {
  final String category;
  final List<Meal> favorites;

  const MealsScreen({
    super.key,
    required this.category,
    required this.favorites,
  });

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  List<Meal> _meals = [];
  List<Meal> _filteredMeals = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String _searchQuery = '';

  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(widget.category),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search meals...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _filterMeals(value);
              },
            ),
          ),
          Expanded(
            child: _filteredMeals.isEmpty && _searchQuery.isNotEmpty
                ? _buildSearchEmpty()
                : _filteredMeals.isEmpty
                ? const Center(
              child: Text(
                'No meals in this category',
                style:
                TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _filteredMeals.length,
                itemBuilder: (context, index) {
                  final meal = _filteredMeals[index];
                  final isFav = widget.favorites
                      .any((m) => m.idMeal == meal.idMeal);
                  return MealCard(
                    meal: meal,
                    isFavorite: isFav,
                    onChangeFavorite: () {
                      setState(() {
                        final idx = widget.favorites.indexWhere(
                                (m) => m.idMeal == meal.idMeal);
                        if (idx >= 0) {
                          widget.favorites.removeAt(idx);
                        } else {
                          widget.favorites.add(meal);
                        }
                      });
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MealDetailScreen(
                                  mealId: meal.idMeal),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchEmpty() {
    return Center();

  }

  void _loadMeals() async {
    final meals = await _apiService.loadMealsByCategory(widget.category);
    setState(() {
      _meals = meals;
      _filteredMeals = meals;
      _isLoading = false;
    });
  }

  void _filterMeals(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredMeals = _meals;
      } else {
        _filteredMeals = _meals
            .where((meal) =>
            meal.strMeal.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }


}

