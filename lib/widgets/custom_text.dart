import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final int? maxLines;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final Lang lang;
  const CustomText({
    Key? key,
    required this.text,
    required this.lang,
    this.fontSize,
    this.textAlign,
    this.color,
    this.maxLines,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(lang == Lang.tr) {
      return Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        style: GoogleFonts.oswald(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      );
    }else if(lang == Lang.ar){
      return Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        style: GoogleFonts.lemonada(
          color: color,
          fontSize: fontSize == null ? 15 : (fontSize! - 5),
          fontWeight: fontWeight,
        ),
      );
    }else{
      return Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        style: GoogleFonts.oswald(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      );
    }
  }
}


enum Lang{
  ar,
  tr
}