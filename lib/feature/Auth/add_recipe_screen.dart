import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:food_track/feature/Auth/Home_view.dart';
import 'package:food_track/product/constants/color_constants.dart';
import 'package:food_track/product/model/recipe.dart';
import 'package:food_track/feature/Auth/fire_base_auth_services.dart';
import 'package:food_track/product/widgets/button/custom_button.dart';
import 'package:food_track/product/widgets/text/xxlargetext.dart';

class AddRecipeScreen extends StatefulWidget {
  final FireBaseAuthService auth = FireBaseAuthService();
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  Map<String, dynamic>? userData;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();
  FireBaseAuthService auth = FireBaseAuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    Map<String, dynamic>? data = await widget.auth.getCurrentUserData();
    setState(() {
      userData = data;
    });
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

  Future<void> _addRecipe(BuildContext context) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (_formKey.currentState!.validate()) {
      final newRecipe = Recipe(
          title: _titleController.text,
          image: _imageController.text,
          ingredients: _ingredientsController.text.split('\n'),
          steps: _stepsController.text.split('\n'),
          userid: userData?['id'].toString());
      try {
        await FirebaseFirestore.instance
            .collection('recipetutorial')
            .add(newRecipe.toMap());
        showSuccesSnacBar('Tarifiniz başarıyla eklendi');
        setState(() {
          _isLoading = false;
        });
        _navigateToHome(context);
      } catch (e) {
        print('Error');
        setState(() {
          _isLoading = false;
        });
        showWrongCredentialSnacBar('Bir hata oluştu !');
      }

      //Navigator.pop(context);
    }
    {
      showWrongCredentialSnacBar('Lütfen alanları eksiksiz giriniz !');
      print('Error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showSuccesSnacBar(String msg) {
    ScaffoldMessenger.of(context)
      ..removeCurrentMaterialBanner()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.green[800],
          content: Text(
            msg,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
  }

  void showWrongCredentialSnacBar(String msg) {
    ScaffoldMessenger.of(context)
      ..removeCurrentMaterialBanner()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[400],
          content: Text(
            msg,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.elevation1,
      appBar: AppBar(
        backgroundColor: ColorConstants.primaryOrange,
        title: const XXlargeText(
          value: 'Tarif Ekle',
          colorVal: ColorConstants.pureWhite,
        ),
        //title: Text(recipe.title ?? 'Tarif Detayı'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Tarif Başlığı'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen tarif başlığını girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Resim URL\'si'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen resim URL\'sini girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                    labelText: 'Malzemeler (Her malzeme için yeni satır)'),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen malzemeleri girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stepsController,
                decoration: const InputDecoration(
                    labelText: 'Adımlar (Her adım için yeni satır)'),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen adımları girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                onTap: () {
                  setState(() {
                    _isLoading = true;
                  });
                  _addRecipe(context);
                },
                buttonText: 'Tarif Ekle',
                isLoading: _isLoading,
              ),
              // ElevatedButton(
              //   onPressed: _addRecipe,
              //   child: Text('Tarif Ekle'),
              //   style: ElevatedButton.styleFrom(
              //     primary: ColorConstants.primaryOrange,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
