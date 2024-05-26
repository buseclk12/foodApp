import 'package:flutter/material.dart';
import 'package:food_track/product/constants/color_constants.dart';
import 'package:kartal/kartal.dart';

class PasswordTextFieldWidget extends StatelessWidget {
  const PasswordTextFieldWidget({
    super.key,
    required TextEditingController passwordController,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingLow,
      child: TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: 'Şifre',
          floatingLabelStyle:
              const TextStyle(color: ColorConstants.primaryOrange),
          prefixIcon: Image.asset('assets/icon/ic_password.png'),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorConstants.pureBlack),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorConstants.primaryOrange),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        obscureText: true,
      ),
    );
  }
}
