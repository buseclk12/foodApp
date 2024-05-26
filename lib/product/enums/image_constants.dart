import 'package:flutter/material.dart';

enum IconConstants {
  microphone('microphone'),
  appIcon('app_logo_2'),
  ;

  final String value;
  const IconConstants(this.value);

  String get toPng => 'assets/icon/ic_$value.png';
  Image get toImage => Image.asset(toPng);
  Image get toAppIconImage => Image.asset(
        toPng,
        height: 71.0,
        width: 258.0,
      );
}
