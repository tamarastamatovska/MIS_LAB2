import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/category_model.dart';
import '../models/meal_model.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import 'favorites_screen.dart';
import 'meals_screen.dart';
import 'meal_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<Meal> favorites;
  final RemoteMessage? initialMessage;

  const HomeScreen({
    super.key,
    required this.favorites,
    this.initialMessage,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> _categories = [];
  List<Category> _filteredCategories = [];
  bool _isLoading = true;

  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _loadCategories();


    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _requestPermission();


      if (widget.initialMessage != null) {
        final msg = widget.initialMessage!;
        if (msg.data['action'] == 'random_recipe') {
          _showRandomMeal();
        }
      }
    });


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground notification: ${message.notification?.title}");

    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("User tapped notification (from background)");
      if (message.data['action'] == 'random_recipe') {
        _showRandomMeal();
      }
    });
  }

  Future<void> _requestPermission() async {

    PermissionStatus status = await Permission.notification.request();
    print("Notification Permission Status: $status");


    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print("Firebase Permission: ${settings.authorizationStatus}");


    String? token = await _messaging.getToken();
    print("FCM Token: $token");
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text('Recipe App - Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FavoritesScreen(favorites: widget.favorites),
                ),
              ).then((_) {
                setState(() {});
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: _showRandomMeal,
          ),
        ],
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
                hintText: 'Search categories...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _filterCategories,
            ),
          ),
          Expanded(
            child: _filteredCategories.isEmpty
                ? const Center(
              child: Text(
                'No categories found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = _filteredCategories[index];
                  return CategoryCard(
                    category: category,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MealsScreen(
                            category: category.strCategory,
                            favorites: widget.favorites,
                          ),
                        ),
                      ).then((_) {
                        setState(() {});
                      });
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

  void _loadCategories() async {
    final categories = await _apiService.loadCategories();
    setState(() {
      _categories = categories;
      _filteredCategories = categories;
      _isLoading = false;
    });
  }

  void _filterCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = _categories;
      } else {
        _filteredCategories = _categories
            .where((category) => category.strCategory
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showRandomMeal() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final meal = await _apiService.getRandomMeal();
    Navigator.pop(context);

    if (meal != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MealDetailScreen(mealId: meal.idMeal),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load random meal')),
      );
    }
  }


}

