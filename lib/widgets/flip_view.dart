import 'package:flutter/material.dart';

import 'custom_text.dart';

class FlipView extends StatelessWidget {
  final String text;
  final Lang lang;
  final Color color;
  final String description;
  const FlipView({
    Key? key,
    required this.text,
    required this.lang,
    required this.color,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(5.0),
      alignment: Alignment.center,
      child: CustomText(
        text: text,
        lang: lang,
        color: Colors.white,
        textAlign: TextAlign.center,
        fontSize: 17,
      ),
      /*Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: text,
            lang: lang,
            color: Colors.white,
            textAlign: TextAlign.center,
            fontSize: 17,
          ),
          CustomText(
            text: description,
            lang: lang,
            color: Colors.white,
            textAlign: TextAlign.center,
            fontSize: 15,
          ),
        ],
      ),*/
    );
  }
}