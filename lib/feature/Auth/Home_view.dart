import 'package:flutter/material.dart';
import 'package:food_track/feature/Auth/add_recipe_screen.dart';
import 'package:food_track/feature/Auth/fire_base_auth_services.dart';
import 'package:food_track/feature/Auth/home_drawer.dart';
import 'package:food_track/feature/Auth/home_provider.dart';
import 'package:food_track/feature/Auth/login_view.dart';
import 'package:food_track/feature/Auth/recipe_detail.dart';
import 'package:food_track/feature/Auth/search_view.dart';
import 'package:food_track/product/constants/color_constants.dart';
import 'package:food_track/product/model/recipe.dart';
import 'package:food_track/product/widgets/text/xxlargetext.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FireBaseAuthService _auth = FireBaseAuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginView(),
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

  void _navigateToAddReceipe(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddRecipeScreen(),
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

  @override
  Widget build(BuildContext context) {
    Future<void> _signOut(BuildContext context) async {
      bool isSignOutSuccess = await _auth.signOut();
      if (isSignOutSuccess) {
        _navigateToLogin(context);
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.reorder,
            color: ColorConstants.pureWhite,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Image.asset(
          'assets/icon/ic_app_logo_2.png',
          height: 40.0,
        ),
        backgroundColor: ColorConstants.primaryOrange,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app,
                color: Colors.white), // Çıkış ikonu ve rengi beyaz
            onPressed: () {
              _signOut(context);
            },
          ),
        ],
      ),
      drawer: HomeDrawer(
        auth: _auth,
      ),
      body: StreamBuilder<List<Recipe>>(
        stream: Provider.of<HomeProvider>(context).getRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Hiç tarif bulunamadı.'));
          }
          final recipes = snapshot.data!.reversed.toList();

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200, // Her kartın maksimum genişliği
              childAspectRatio:
                  0.85, // Kartın boyut oranı (genişlik / yükseklik)
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailScreen(recipe: recipe),
                    ),
                  );
                },
                child: Card(
                  color: ColorConstants.primaryOrange,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.network(
                        recipe.image ?? '',
                        fit: BoxFit.cover,
                        height: 150,
                        width: 150,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: XXlargeText(
                            value: recipe.title ?? 'Tarif Başlığı',
                            colorVal: ColorConstants.pureWhite),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Colors.grey.shade300,
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchView(),
                    ),
                  );
                },
              ),
              label: 'Ara',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddRecipeScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.add_a_photo,
                  color: ColorConstants.focusBlack, // Renk değiştirilebilir
                ),
              ),
              label: 'Tarif Ekle',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: _openDrawer,
                icon: const Icon(
                  Icons.person,
                  color: ColorConstants.focusBlack, // Renk değiştirilebilir
                ),
              ),
              label: 'Profil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: ColorConstants.primaryOrange,
          unselectedItemColor: Colors.black,
        ),
      ),
    );
  }
}

Widget _buildCategorySection(
    BuildContext context, String title, int itemCount) {
  double screenWidth = MediaQuery.of(context).size.width;
  // Kart genişliğini ekran genişliğine göre hesapla ve yan boşlukları düşür
  double cardWidth =
      (screenWidth / 2) - (16 * 2); // 2 kartı tam sığdırmak için genişlik

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(
            8.0, 8.0, 8.0, 0), // Başlık altındaki boşluğu azalt
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            TextButton(
              onPressed: () {
                // TODO: 'TÜMÜNÜ GÖR' butonunun işlevselliği
              },
              child: Text(
                'TÜMÜNÜ GÖR',
                style: TextStyle(
                  color: ColorConstants.primaryOrange,
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 8), // Başlık ile kartlar arasındaki boşluğu ayarla
      Container(
        height: 200, // Kartların yüksekliğini ayarla
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return _buildFoodCard(context, index, cardWidth);
          },
        ),
      ),
    ],
  );
}

Widget _buildFoodCard(BuildContext context, int index, double width) {
  return Container(
    width: width,
    margin: EdgeInsets.symmetric(
        horizontal: 8, vertical: 4), // Sağ ve sol boşlukları ayarla
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: ColorConstants.primaryOrange,
          padding: EdgeInsets.symmetric(vertical: 4),
          width: double.infinity, // Container'ı tam genişlik yap
          child: Text(
            'Kişi $index',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: Image.network(
            'https://via.placeholder.com/150',
            width: double.infinity, // Resmi tam genişlik yap
            fit: BoxFit.cover,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(Icons.comment, color: Colors.grey),
            Text('Yorum $index', style: TextStyle(color: Colors.grey)),
            Icon(Icons.favorite, color: Colors.red),
            Text('Beğeni $index', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    ),
  );
}
