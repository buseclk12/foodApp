import 'package:flutter/material.dart';
import 'package:food_track/feature/Auth/recipe_detail.dart';
import 'package:food_track/product/constants/color_constants.dart';
import 'package:food_track/product/model/recipe.dart';
import 'package:provider/provider.dart';
import 'package:food_track/feature/Auth/home_provider.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Tarif Ara...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white, fontSize: 18.0),
          onChanged: (value) {
            setState(() {
              query = value;
            });
          },
        ),
        backgroundColor: ColorConstants.primaryOrange,
      ),
      body: query.isEmpty
          ? Center(child: Text('Lütfen aramak için bir şeyler yazın'))
          : StreamBuilder<List<Recipe>>(
              stream: Provider.of<HomeProvider>(context).searchRecipes(query),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Bir hata oluştu.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Hiç tarif bulunamadı.'));
                }

                final recipes = snapshot.data!;

                return ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return ListTile(
                      leading: Image.network(
                        recipe.image ?? '',
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                      title: Text(recipe.title ?? 'Tarif Başlığı'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RecipeDetailScreen(recipe: recipe),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
