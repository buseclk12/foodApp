import 'package:flutter/material.dart';
import 'package:food_track/feature/Auth/login_view.dart';
import 'package:food_track/product/constants/color_constants.dart';
import 'package:food_track/product/widgets/text/xlargetext.dart';
import 'package:food_track/product/widgets/text/xxlargetext.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginView()),
    );
  }

  Widget _buildImage(String assetName, [double width = 294]) {
    return Image.asset('assets/image/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle bodyStyle = GoogleFonts.nunito(
      textStyle: const TextStyle(
          color: ColorConstants.textColor,
          fontSize: 15.0,
          fontWeight: FontWeight.w700,
          height: 1.5),
    );
    PageDecoration pageDecoration = PageDecoration(
      titleTextStyle: const TextStyle(
          color: ColorConstants.pureBlack,
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
          height: 1.3),
      bodyTextStyle: bodyStyle,
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: 4000,
      infiniteAutoScroll: true,
      globalHeader: const Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 16, right: 16),
          ),
        ),
      ),
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const XXlargeText(
            value: 'Let\'s go right away!',
            colorVal: ColorConstants.focusBlack,
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Welcome to Fodamy Network!",
          body:
              "Fodamy is the best place to find your favorite recipes in all around the word.",
          image: _buildImage('img_onboard_1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Finding recipes were not that easy.",
          body:
              "Fodamy is the best place to find your favorite recipes in all around the word.",
          image: _buildImage('img_onboard_2.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Add new recipe.",
          body:
              "Fodamy is the best place to find your favorite recipes in all around the word.",
          image: _buildImage('img_onboard_3.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Share recipes with others.",
          body:
              "Fodamy is the best place to find your favorite recipes in all around the word.",
          image: _buildImage('img_onboard_4.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const XlargeText(
        value: "Skip",
        colorVal: ColorConstants.pureWhite,
      ),
      next: const Icon(Icons.arrow_forward, color: ColorConstants.pureWhite),
      done: const XlargeText(
        value: "Done",
        colorVal: ColorConstants.pureWhite,
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: ColorConstants.primaryOrange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
