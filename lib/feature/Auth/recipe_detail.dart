import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_track/product/constants/color_constants.dart';
import 'package:food_track/product/model/recipe.dart';
import 'package:food_track/product/widgets/text/largetext.dart';
import 'package:food_track/product/widgets/text/mediumtext.dart';
import 'package:food_track/product/widgets/text/xxlargetext.dart';
import 'package:food_track/feature/Auth/edit_recipe_screen.dart';
import 'package:kartal/kartal.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  RecipeDetailScreen({required this.recipe});

  Future<DocumentSnapshot> getUserData(String userId) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
  }

  void _navigateToEditRecipe(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecipeScreen(recipe: recipe),
      ),
    );
  }

  Future<void> _deleteRecipe(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.uid != recipe.userid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: XXlargeText(
              value: "Bu tarife erişim izniniz yok!",
              colorVal: ColorConstants.pureWhite),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('recipetutorial')
          .where('title', isEqualTo: recipe.title)
          .where('userid', isEqualTo: currentUser.uid)
          .limit(1)
          .get();

      if (doc.docs.isNotEmpty) {
        await doc.docs.first.reference.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tarif başarıyla silindi!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tarif bulunamadı veya erişim izni yok!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bir hata oluştu!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorConstants.elevation1,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_return_rounded,
            color: ColorConstants.pureWhite,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: ColorConstants.primaryOrange,
        title: XXlargeText(
          value: recipe.title ?? 'Tarif Detayı',
          colorVal: ColorConstants.pureWhite,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.green.shade700),
            onPressed: () => _navigateToEditRecipe(context),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.brown.shade700),
            onPressed: () => _deleteRecipe(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(recipe.image ?? ''),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    recipe.title ?? '',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                FutureBuilder<DocumentSnapshot>(
                  future: getUserData(recipe.userid!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Kullanıcı bilgileri yüklenemedi.');
                    } else if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Text('Kullanıcı bulunamadı.');
                    }

                    var userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Row(
                      children: [
                        Image.network(
                          userData['profilePictureUrl'],
                          width: 30,
                          height: 30,
                        ),
                        XXlargeText(
                            value: ' ${userData['username']}',
                            colorVal: ColorConstants.pureBlack),
                      ],
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Malzemeler:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Wrap(
              children: recipe.ingredients?.map((ingredient) {
                    return LargeText(
                      value: '• $ingredient\n',
                    );
                  }).toList() ??
                  [],
            ),
            SizedBox(height: 16),
            const Text(
              'Adımlar:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Wrap(
              children: recipe.steps?.map((step) {
                    return LargeText(value: '• $step\n');
                  }).toList() ??
                  [],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
