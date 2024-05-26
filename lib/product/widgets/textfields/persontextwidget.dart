import 'package:flutter/material.dart';
import 'package:food_track/product/constants/color_constants.dart';
import 'package:kartal/kartal.dart';

class PersonTextFieldWidget extends StatelessWidget {
  const PersonTextFieldWidget({
    super.key,
    required TextEditingController personNameController,
  }) : _personNameController = personNameController;

  final TextEditingController _personNameController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingLow,
      child: TextFormField(
        controller: _personNameController,
        decoration: InputDecoration(
          focusColor: ColorConstants.primaryOrange,
          labelText: 'Kullanıcı Adı',
          floatingLabelStyle:
              const TextStyle(color: ColorConstants.primaryOrange),
          prefixIcon: Image.asset('assets/icon/ic_person.png'),
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
