import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class XXlargeText extends StatelessWidget {
  const XXlargeText({
    super.key,
    required this.value,
    required this.colorVal,
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
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
            height: 1.3),
      ),
    );
  }
}
