// This page has been removed
/*
import 'package:langquiz/models/word_model.dart';
import 'package:langquiz/providers/main_provider.dart';
import 'package:langquiz/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WordPage extends StatelessWidget {
  final int index;
  const WordPage({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MainProvider>(
        builder: (context, provider, _){
          return WillPopScope(
            onWillPop: () async{
              provider.clearPageController();
              return true;
            },
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: PageView.builder(
                    itemCount: provider.words.length,
                    controller: provider.getPageController(index),
                    itemBuilder: (context, i){
                      return WordCard(
                        words: provider.words[i],
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: TextButton(
                      onPressed: () => provider.nextWordPage(context),
                      child: Container(
                        height: 40,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              text: provider.isWordPageEnd ? AppLocalizations.of(context)!.end : AppLocalizations.of(context)!.next,
                              lang: Provider.of<MainProvider>(context).locale.languageCode == 'ar' ? Lang.ar : Lang.tr,
                              color: Colors.grey[300],
                            ),
                            provider.isWordPageEnd
                                ?
                            const SizedBox()
                                :
                            Icon(Icons.arrow_forward_ios, color: Colors.grey[300],),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class WordCard extends StatelessWidget {
  final WordModel words;
  const WordCard({
    Key? key,
    required this.words,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Positioned(
            top: 100,
            left: 50,
            child: Container(
              width: 250.0,
              height: 150.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.blue,
                      blurRadius: 7,
                    ),
                  ]
              ),
              child: CustomText(
                text: Provider.of<MainProvider>(context).locale.languageCode == 'ar' ? words.arabic! : words.turkish!,
                lang: Provider.of<MainProvider>(context).locale.languageCode == 'ar' ? Lang.ar : Lang.tr,
                fontSize: 21,
              ),
            ),
          ),
          Positioned(
            left: 130,
            top: 85,
            child: Container(
              width: 90.0,
              height: 50.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          Positioned(
            left: 140,
            top: 75,
            child: Container(
              width: 70.0,
              height: 50.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.blue,
                      blurRadius: 7,
                    ),
                  ]
              ),
              child: CustomText(
                text: Provider.of<MainProvider>(context).locale.languageCode == 'ar' ? words.turkish! : words.arabic!,
                lang: Provider.of<MainProvider>(context).locale.languageCode == 'ar' ? Lang.ar : Lang.tr,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/