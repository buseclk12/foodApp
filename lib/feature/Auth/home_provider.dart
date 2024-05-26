import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_track/product/model/recipe.dart';

class HomeProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Recipe>> getRecipes() {
    return _firestore.collection('recipetutorial').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Recipe.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<Recipe>> searchRecipes(String query) {
    if (query.isEmpty) {
      return Stream.value([]); // Boş sorgu durumunda boş bir liste döndür
    }

    return _firestore.collection('recipetutorial').snapshots().map((snapshot) {
      final results = snapshot.docs
          .where((doc) {
            final title = doc['title'] as String?;
            return title != null &&
                title.toLowerCase().contains(query.toLowerCase());
          })
          .map((doc) => Recipe.fromJson(doc.data()))
          .toList();
      return results;
    });
  }
}
