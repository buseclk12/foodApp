import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_track/feature/Auth/Home_view.dart';
import 'package:food_track/product/constants/color_constants.dart';
import 'package:food_track/product/model/recipe.dart';
import 'package:food_track/product/widgets/text/xxlargetext.dart';

class EditRecipeScreen extends StatefulWidget {
  final Recipe recipe;

  EditRecipeScreen({required this.recipe});

  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _ingredientsController.text = widget.recipe.ingredients?.join('\n') ?? '';
    _stepsController.text = widget.recipe.steps?.join('\n') ?? '';
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1, 0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  Future<void> _updateRecipe() async {
    setState(() {
      _isLoading = true;
    });

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Giriş yapılmadı!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updatedRecipe = widget.recipe.copyWith(
      ingredients: _ingredientsController.text.split('\n'),
      steps: _stepsController.text.split('\n'),
    );

    try {
      final doc = await FirebaseFirestore.instance
          .collection('recipetutorial')
          .where('title', isEqualTo: widget.recipe.title)
          .where('userid', isEqualTo: currentUser.uid)
          .limit(1)
          .get();

      if (doc.docs.isNotEmpty) {
        await doc.docs.first.reference.update(updatedRecipe.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tarif başarıyla güncellendi!'),
            backgroundColor: Colors.green,
          ),
        );
        _navigateToHome(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: XXlargeText(
              colorVal: ColorConstants.pureWhite,
              value: "Erişim izni yok !",
            ),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
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
      appBar: AppBar(
        backgroundColor: ColorConstants.primaryOrange,
        title: const XXlargeText(
          value: 'Tarif Düzenle',
          colorVal: ColorConstants.pureWhite,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            XXlargeText(
                value: widget.recipe.title ?? '',
                colorVal: ColorConstants.pureBlack),
            Image.network(widget.recipe.image ?? ''),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ingredientsController,
              maxLines: null,
              decoration: InputDecoration(labelText: 'Malzemeler'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _stepsController,
              maxLines: null,
              decoration: InputDecoration(labelText: 'Adımlar'),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _updateRecipe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.primaryOrange,
                    ),
                    child: const XXlargeText(
                      colorVal: ColorConstants.pureWhite,
                      value: "Kaydet",
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
