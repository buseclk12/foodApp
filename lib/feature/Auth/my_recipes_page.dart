import 'package:flutter/material.dart';
import 'package:food_track/feature/Auth/edit_recipe_screen.dart';
import 'package:food_track/feature/Auth/fire_base_auth_services.dart';
import 'package:food_track/product/constants/color_constants.dart';
import 'package:food_track/product/model/recipe.dart';
import 'package:food_track/product/widgets/text/xxlargetext.dart';

class MyRecipesPage extends StatefulWidget {
  final FireBaseAuthService auth;
  const MyRecipesPage({super.key, required this.auth});

  @override
  State<MyRecipesPage> createState() => _MyRecipesPageState();
}

class _MyRecipesPageState extends State<MyRecipesPage> {
  List<Recipe> userRecipes = [];
  String? userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserRecipes();
  }

  Future<void> _fetchUserRecipes() async {
    setState(() {
      isLoading = true;
    });

    List<Recipe> recipes = await widget.auth.getUserRecipes();

    setState(() {
      userRecipes = recipes;
      isLoading = false;
    });
  }

  void _deleteRecipe(String title) async {
    await widget.auth.deleteRecipeByTitle(title);
    _fetchUserRecipes();
  }

  void _updateRecipe(String title) {
    // Güncelleme işlemi için navigasyon eklenebilir
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: XXlargeText(
          colorVal: ColorConstants.pureWhite,
          value: "Yemek Tariflerim",
        ),
        backgroundColor: ColorConstants.primaryOrange,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userRecipes.isEmpty
              ? Center(child: Text('Henüz bir yemek tarifiniz yok'))
              : ListView.builder(
                  itemCount: userRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = userRecipes[index];
                    return ListTile(
                      leading: recipe.image != null
                          ? Image.network(
                              recipe.image!,
                              height: 75,
                              width: 75,
                            )
                          : null,
                      title: Text(recipe.title ?? 'No Title'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditRecipeScreen(recipe: recipe),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteRecipe(recipe.title!),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
