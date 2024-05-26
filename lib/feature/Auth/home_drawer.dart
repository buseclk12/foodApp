import 'package:flutter/material.dart';
import 'package:food_track/feature/Auth/fire_base_auth_services.dart';
import 'package:food_track/feature/Auth/my_recipes_page.dart';
import 'package:food_track/product/constants/color_constants.dart';
import 'package:food_track/product/widgets/text/xxlargetext.dart';
//import 'my_recipes_page.dart'; // Yeni sayfa import ediliyor

class HomeDrawer extends StatefulWidget {
  final FireBaseAuthService auth;
  const HomeDrawer({super.key, required this.auth});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  Map<String, dynamic>? userData;

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

  @override
  Widget build(BuildContext context) => Drawer(
        backgroundColor: ColorConstants.focusBlack,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
      );

  Widget buildMenuItems(BuildContext context) => Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userData?['username'] ?? 'Username'),
            accountEmail: Text(userData?['email'] ?? 'Email'),
            decoration:
                const BoxDecoration(color: ColorConstants.primaryOrange),
            currentAccountPicture: Image.network(userData?[
                    'profilePictureUrl'] ??
                'https://static.vecteezy.com/system/resources/thumbnails/009/734/564/small_2x/default-avatar-profile-icon-of-social-media-user-vector.jpg'),
          ),
          ListTile(
            leading: const Icon(
              Icons.receipt,
              color: ColorConstants.pureWhite,
            ),
            title: const XXlargeText(
              colorVal: ColorConstants.pureWhite,
              value: "Yemek Tariflerim",
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyRecipesPage(auth: widget.auth),
                ),
              );
            },
          ),
        ],
      );
}
