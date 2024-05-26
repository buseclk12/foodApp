import 'package:flutter/material.dart';
import 'package:food_track/product/widgets/text/xxlargetext.dart';

class CustomLargeButtonWidget extends StatelessWidget {
  const CustomLargeButtonWidget(
      {super.key, required this.value, this.textColor, this.bgColor});
  final String value;
  final Color? textColor;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(
          const Size(double.infinity, 58), // Genişlik ve yükseklik değerleri
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0), // Kenar yarıçapı
            side: const BorderSide(
                color: Colors.transparent), // İsteğe bağlı: Kenar rengi
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color?>(bgColor),
      ),
      child: XXlargeText(
        colorVal: textColor,
        value: value,
      ),
    );
  }
}
