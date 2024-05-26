import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class XsmallText extends StatelessWidget {
  const XsmallText({
    required this.value,
    required this.colorVal,
    super.key,
  });
  final String value;
  final Color? colorVal;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: GoogleFonts.nunito(
        textStyle: TextStyle(
            color: colorVal,
            fontSize: 13.0,
            fontWeight: FontWeight.w700,
            height: 1.272),
      ),
    );
  }
}
