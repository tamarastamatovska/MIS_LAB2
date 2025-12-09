import 'package:flutter/material.dart';
import '../models/meal_model.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;
  final VoidCallback? onChangeFavorite;
  final bool isFavorite;

  const MealCard({
    super.key,
    required this.meal,
    required this.onTap,
    this.onChangeFavorite,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  meal.strMealThumb,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      meal.strMeal,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onChangeFavorite != null)
                    GestureDetector(
                      onTap: onChangeFavorite!,
                      child: Icon(
                        isFavorite ? Icons.bookmark : Icons.bookmark_border,
                        color: isFavorite ? Colors.yellow : Colors.grey[600],
                        size: 24,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
