import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_track/feature/Auth/Home_view.dart';
import 'package:food_track/feature/Auth/fire_base_auth_services.dart';
import 'package:food_track/product/constants/color_constants.dart';
import 'package:food_track/product/widgets/button/custom_button.dart';
import 'package:food_track/product/widgets/text/xsmalltext.dart';
import 'package:food_track/product/widgets/text/xxlargetext.dart';
import 'package:food_track/product/widgets/textfields/emailtextwidget.dart';
import 'package:food_track/product/widgets/textfields/passwordtextwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'package:food_track/feature/Auth/register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final FireBaseAuthService _auth = FireBaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Padding(
          padding: context.paddingLow,
          child: Column(children: [
            const SizedBox(
              height: 75,
            ),
            const XXlargeText(
                value: "Giriş Yap", colorVal: ColorConstants.pureBlack),
            const SizedBox(
              height: 35,
            ),
            EmailTextFieldWidget(emailController: _emailController),
            const SizedBox(
              height: 20,
            ),
            PasswordTextFieldWidget(passwordController: _passwordController),
            const SizedBox(
              height: 25,
            ),
            //Button
            CustomButton(
              onTap: () {
                setState(() {
                  _isLoading = true;
                });
                _loginwithEmailandPassword(context);
              },
              buttonText: 'Giriş Yap',
              isLoading: _isLoading,
            ),
            //forget password field.
            const Padding(
              padding: EdgeInsets.only(top: 10.0, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  XsmallText(
                      value: "Şifrenizi mi unuttunuz ?",
                      colorVal: ColorConstants.elevation2),
                ],
              ),
            ),
          ]),
        )),
        persistentFooterButtons: [
          Padding(
            padding: context.onlyBottomPaddingLow,
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const RegisterView(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1, 0);
                      const end = Offset.zero;
                      const curve = Curves.elasticOut;

                      final tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    /*defining default style is optional */
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Hesabın mı yok?',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              color: ColorConstants.textColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              height: 1.33),
                        ),
                      ),
                      TextSpan(
                        text: '  Üye Ol',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              color: ColorConstants.primaryOrange,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              height: 1.33),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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

  Future<void> _loginwithEmailandPassword(BuildContext context) async {
    String email = _emailController.text;
    //trim the coming email from login page
    String cleanTextemail = email.replaceAll(RegExp(r'\s+'), '');
    String password = _passwordController.text;
    _emailController.clear();
    _passwordController.clear();
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    User? user =
        await _auth.signInWithEmailAndPassword(cleanTextemail, password);
    if (user != null) {
      showSuccesSnacBar('Succesfully Login!');

      print('Successfully Login!!!');
      setState(() {
        _isLoading = false;
      });
      _navigateToHome(context);
    } else {
      showWrongCredentialSnacBar('Wrong Password or Email');
      setState(() {
        _isLoading = false;
      });
    }
  }
}
