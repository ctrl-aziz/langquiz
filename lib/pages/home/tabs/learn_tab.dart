import 'package:langquiz/pages/learning_page.dart';
import 'package:langquiz/providers/main_provider.dart';
import 'package:langquiz/widgets/custom_button.dart';
import 'package:langquiz/widgets/custom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../widgets/custom_text.dart';

class LearnTab extends StatelessWidget {
  const LearnTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;
    return Column(
      children: [
        const SizedBox(
          height: 30.0,
        ),
        Expanded(
          flex: 1,
          child: CustomText(
            text: translate.choose_learning_level,
            lang: Provider.of<MainProvider>(context).locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
            fontSize: 17,
          ),
        ),
        Expanded(
          flex: 12,
          child: Consumer<MainProvider>(
            builder: (context, provider, _){
              return ListView.builder(
                itemCount: provider.levels.length,
                itemBuilder: (context, i){
                  return CustomButton(
                    onPressed: (){
                      provider.level = provider.levels[i];
                      print(provider.level);
                      provider.getLearningWords(context);
                      CustomNavigator.push(context, LearningPage(provider.levelsName(context)[provider.levels[i]]!));
                    },
                    text: provider.levelsName(context)[provider.levels[i]]!,
                    icon: provider.levels[i],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}