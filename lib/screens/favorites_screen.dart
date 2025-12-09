import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Meal> favorites;

  const FavoritesScreen({
    super.key,
    required this.favorites,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text('Favorite Recipes'),
      ),
      body: widget.favorites.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'You do not have favorite recipes yet!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: widget.favorites.length,
          itemBuilder: (context, index) {
            final meal = widget.favorites[index];
            return MealCard(
              meal: meal,
              isFavorite: true,
              onChangeFavorite: () {
                setState(() {
                  widget.favorites.removeAt(index);
                });
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MealDetailScreen(mealId: meal.idMeal),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
