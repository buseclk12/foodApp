import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_track/feature/Auth/Home_view.dart';
import 'package:food_track/feature/onboarding/onboarding_view.dart';
import 'package:food_track/product/constants/color_constants.dart';
import 'package:food_track/product/enums/image_constants.dart';

// ignore: must_be_immutable
class SplashView extends StatefulWidget {
  SplashView({
    required this.goToMainScreen,
    required this.showOnboardingPages,
    super.key,
  });

  bool goToMainScreen;
  bool showOnboardingPages;

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  void gotoOnboarding() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const OnboardingView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1, 0);
          const end = Offset.zero;
          const curve = Curves.elasticOut;

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
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    Future.delayed(const Duration(seconds: 4), () {
      if (FirebaseAuth.instance.currentUser != null) {
        widget.goToMainScreen = true;
        _navigateToHome(context);
      }

      if (widget.goToMainScreen == false &&
          widget.showOnboardingPages == true) {
        gotoOnboarding();
      }

      //eger bir kullanıcı yok ve onboarding true ise
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryOrange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconConstants.appIcon.toAppIconImage,
          ],
        ),
      ),
    );
  }
}

void _navigateToHome(BuildContext context) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const HomeView(),
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
