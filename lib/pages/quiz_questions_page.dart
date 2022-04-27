import 'package:langquiz/providers/main_provider.dart';
import 'package:langquiz/widgets/custom_button.dart';
import 'package:langquiz/widgets/custom_text.dart';
import 'package:langquiz/widgets/question_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuizQuestionsPage extends StatelessWidget {
  final String title;
  const QuizQuestionsPage(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (context, provider, _){
        return Scaffold(
          appBar: AppBar(
            title: CustomText(
              text: title,
              lang: provider.locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
              color: Colors.black,
            ),
          ),
          body: WillPopScope(
            onWillPop: ()=> provider.willPop(context),
            child: PageView.builder(
              itemCount: provider.quiz.length,
              physics: const NeverScrollableScrollPhysics(),
              controller: provider.pageController,
              itemBuilder: (context, pageIndex){
                if (kDebugMode) {
                  print("provider.quiz: ${provider.quiz.length}");
                }
                return Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xff267DB2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomText(
                              text: "${AppLocalizations.of(context)!.errors}:  ${provider.errorsCount}/3",
                              lang: provider.locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
                              color: Colors.grey[300],
                            ),
                            CustomText(
                              text: "${AppLocalizations.of(context)!.level}: ${title.replaceAll(title.split(" ").first, "")}",
                              lang: provider.locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
                              color: Colors.grey[300],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: provider.locale!.languageCode == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: QuestionView(
                            questNumb: "${pageIndex+1}) ",
                            questText: provider.locale!.languageCode == 'ar' ? provider.quiz[pageIndex].turkish! : provider.quiz[pageIndex].arabic!,
                            langCode: provider.locale!.languageCode,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 12,
                      child: ListView.builder(
                        itemCount: provider.quiz[pageIndex].answers!.length,
                        itemBuilder: (context, listIndex){
                          return CustomButton(
                            onPressed: () async{
                              await provider.chooseAnswer(context, pageIndex, listIndex);
                            },
                            text: provider.quiz[pageIndex].answers![listIndex],
                            icon: provider.optionsChar[listIndex],
                            selected: provider.isSelected(pageIndex, listIndex),
                            isRightAnswer: provider.isRightAnswer(pageIndex, listIndex),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(
                          text: "${pageIndex+1}/20 ",
                          lang: provider.locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}