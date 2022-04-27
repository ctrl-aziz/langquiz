import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'custom_text.dart';

class QuestionView extends StatelessWidget {
  final String questNumb;
  final String questText;
  final String langCode;
  const QuestionView({
    Key? key,
    required this.questNumb,
    required this.questText,
    required this.langCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(langCode == 'ar'){
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              text: questNumb,
              lang: langCode == 'ar' ? Lang.ar : Lang.tr,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),

          CustomText(
            text: AppLocalizations.of(context)!.what_mean,
            lang: langCode == 'ar' ? Lang.ar : Lang.tr,
            fontSize: 17,
          ),
          const SizedBox(width: 5.0,),
          CustomText(
            text: questText,
            lang: langCode == 'ar' ? Lang.tr : Lang.ar,
          ),
          const SizedBox(width: 5.0,),
          const CustomText(
            text: '؟',
            lang: Lang.ar,
          ),
        ],
      );
    }else{
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              text: questNumb,
              lang: langCode == 'ar' ? Lang.ar : Lang.tr,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          CustomText(
            text: questText,
            lang: langCode == 'ar' ? Lang.tr : Lang.ar,
          ),
          const SizedBox(width: 13.0,),
          CustomText(
            text: AppLocalizations.of(context)!.what_mean,
            lang: langCode == 'ar' ? Lang.ar : Lang.tr,
            fontSize: 17,
          ),
          const SizedBox(width: 3.0,),
          const CustomText(
            text: '?',
            lang: Lang.tr,
          ),
        ],
      );
    }
  }
}