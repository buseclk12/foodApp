import 'package:flutter/material.dart';
import 'package:food_track/product/constants/color_constants.dart';
import 'package:food_track/product/widgets/text/xxlargetext.dart';
import 'package:kartal/kartal.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonText;
  final bool isLoading;

  const CustomButton(
      {super.key,
      required this.onTap,
      required this.buttonText,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: context.paddingLow,
        child: Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            color: ColorConstants.primaryOrange,
            borderRadius: BorderRadius.circular(10),
          ),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.green[200],
                  ),
                )
              : Center(
                  child: XXlargeText(
                    value: buttonText,
                    colorVal: ColorConstants.elevation0,
                  ),
                ),
        ),
      ),
    );
  }
}
