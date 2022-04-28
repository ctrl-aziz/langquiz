import 'package:langquiz/pages/quiz_questions_page.dart';
import 'package:langquiz/providers/main_provider.dart';
import 'package:langquiz/widgets/custom_button.dart';
import 'package:langquiz/widgets/custom_navigator.dart';
import 'package:langquiz/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuizTab extends StatelessWidget {
  const QuizTab({Key? key}) : super(key: key);

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
            text: translate.choose_quiz_level,
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
                    onPressed: () async{
                      provider.level = provider.levels[i];
                      await provider.getQuiz(context);
                      CustomNavigator.push(context,
                        QuizQuestionsPage(
                          "${provider.levels[i]} ${provider.levelsName(context)[provider.levels[i]]}",
                        ),
                      );
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