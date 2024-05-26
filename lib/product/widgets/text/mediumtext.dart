import 'package:flutter/material.dart';
import 'package:food_track/product/constants/color_constants.dart';
import 'package:google_fonts/google_fonts.dart';

class mediumText extends StatelessWidget {
  const mediumText({
    required this.value,
    super.key,
  });
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: GoogleFonts.nunito(
        textStyle: const TextStyle(
            color: ColorConstants.focusBlack,
            fontSize: 13.0,
            fontWeight: FontWeight.w700,
            height: 1.38),
      ),
    );
  }
}
