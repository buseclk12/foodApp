import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_track/feature/Auth/fire_base_auth_services.dart';
import 'package:food_track/feature/Auth/login_view.dart';
import 'package:food_track/product/constants/color_constants.dart';
import 'package:food_track/product/widgets/button/custom_button.dart';
import 'package:food_track/product/widgets/text/xxlargetext.dart';
import 'package:food_track/product/widgets/textfields/emailtextwidget.dart';
import 'package:food_track/product/widgets/textfields/passwordtextwidget.dart';
import 'package:food_track/product/widgets/textfields/persontextwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final FireBaseAuthService _auth = FireBaseAuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
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
          color: Color.fromARGB(0, 231, 168, 168),
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
                value: "Üye Ol", colorVal: ColorConstants.pureBlack),
            const SizedBox(
              height: 35,
            ),
            PersonTextFieldWidget(personNameController: _usernameController),
            const SizedBox(
              height: 15,
            ),
            EmailTextFieldWidget(emailController: _emailController),
            const SizedBox(
              height: 15,
            ),
            PasswordTextFieldWidget(passwordController: _passwordController),
            const SizedBox(
              height: 20,
            ),
            //Button
            CustomButton(
              onTap: () {
                setState(() {
                  _isLoading = true;
                });
                _signUpWithEmailAndPasswordAndSavetoUserCollection(context);
              },
              buttonText: 'Üye Ol',
              isLoading: _isLoading,
            ),
            //forget password field.
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
                        const LoginView(),
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
                        text: 'Hesabın mı var?',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              color: ColorConstants.textColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              height: 1.33),
                        ),
                      ),
                      TextSpan(
                        text: '  Giriş yap',
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
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
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

  Future<void> _signUpWithEmailAndPasswordAndSavetoUserCollection(
      BuildContext context) async {
    String email = _emailController.text;
    String userName = _usernameController.text;
    String password = _passwordController.text;

    String cleanTextemail = email.replaceAll(RegExp(r'\s+'), '');
    _emailController.clear();
    _passwordController.clear();
    _usernameController.clear();
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    User? user = await _auth.signUpWithEmailAndPasswordAndAddToFirestore(
        email, password, userName);
    if (user != null) {
      showSuccesSnacBar('Succesfully Registered!');

      print('Successfully Registered!!!');
      setState(() {
        _isLoading = false;
      });
      _navigateToLogin(context);
    } else {
      showWrongCredentialSnacBar('Something went wrong, try again.');
      setState(() {
        _isLoading = false;
      });
    }
  }
}
