import 'package:flutter/material.dart';
import 'package:food_track/product/constants/color_constants.dart';
import 'package:kartal/kartal.dart';

class EmailTextFieldWidget extends StatelessWidget {
  const EmailTextFieldWidget({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingLow,
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          focusColor: ColorConstants.primaryOrange,
          labelText: 'E-mail Adresi',
          floatingLabelStyle:
              const TextStyle(color: ColorConstants.primaryOrange),
          prefixIcon: Image.asset('assets/icon/ic_mail.png'),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorConstants.pureBlack),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorConstants.primaryOrange),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}
