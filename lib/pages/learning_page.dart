import 'package:langquiz/config/resource.dart';
import 'package:langquiz/providers/main_provider.dart';
import 'package:langquiz/widgets/custom_text.dart';
import 'package:langquiz/widgets/flip_view.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LearningPage extends StatelessWidget {
  final String title;
  const LearningPage(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
          body: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  provider.words.isEmpty ?
                  TextButton(
                    onPressed: () => provider.getMoreLearningWords(context),
                    child: CustomText(
                      text: AppLocalizations.of(context)!.learn_more,
                      lang: provider.locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
                    ),
                  ) :
                  Wrap(
                    children: List.generate(
                      provider.words.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Draggable<int>(
                            data: i,
                            feedback: Container(
                              width: size.width/4,
                              height: size.width/4,
                              decoration: const BoxDecoration(
                                color: Color(0xff267DB2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    provider.locale!.languageCode == 'ar' ? provider.words[i].turkish! : provider.words[i].arabic!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            child: SizedBox(
                          width: size.width/4,
                          height: size.width/4,
                          child: FlipCard(
                            onFlip: (){
                              //TODO: Add word to database
                              if (kDebugMode) {
                                print("_cardController: ");
                              }
                            },
                            front: FlipView(
                              text: provider.locale!.languageCode == 'ar' ? provider.words[i].turkish! : provider.words[i].arabic!,
                              lang: provider.locale!.languageCode == 'ar' ? Lang.tr : Lang.ar,
                              color: const Color(0xff267DB2),
                              description: provider.words[i].turkishDesc??"",
                            ),
                            back: FlipView(
                              text: provider.locale!.languageCode == 'ar' ? provider.words[i].arabic! : provider.words[i].turkish!,
                              lang: provider.locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
                              color: const Color(0xffFF6A6B),
                              description: provider.words[i].arabicDesc??"",
                            ),
                          ),
                      ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    width: size.width/4,
                    height: size.width/4,
                    decoration: const BoxDecoration(
                      color: Color(0xff14990A),
                      shape: BoxShape.circle
                    ),
                    child: DragTarget<int>(
                      builder: (BuildContext context, List<Object?> candidateData, List<dynamic> rejectedData) {
                        if(provider.isWordSaving){
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.asset(
                              R.ASSETS_BOX_GIF,
                              color: Colors.white,
                            ),
                          );
                        }else{
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              R.ASSETS_BOX_PNG,
                              color: Colors.white,
                            ),
                          );
                        }
                      },
                      onMove: (DragTargetDetails targetDetails){
                        provider.isWordSaving = true;
                      },
                      onAccept: provider.onAccept,
                      onLeave: (data){
                        provider.isWordSaving = false;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


