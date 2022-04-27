import 'package:langquiz/config/resource.dart';
import 'package:langquiz/pages/home/home_page.dart';
import 'package:langquiz/providers/main_provider.dart';
import 'package:langquiz/widgets/custom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashProvider extends ChangeNotifier{
  final List<String> assets = [
    R.ASSETS_01_SVG,
    R.ASSETS_02_SVG,
    R.ASSETS_03_SVG,
  ];


  final PageController pageController = PageController();

  bool isLastPage = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SplashProvider(){
    pageController.addListener(() {
      isLastPage = pageController.page!.round() >= assets.length-1;
      notifyListeners();
    });
  }

  List<String> titles(BuildContext context) {
    final translate = AppLocalizations.of(context)!;
    return [
      translate.develop_your_lang_skills,
      translate.answer_quiz,
      translate.learn_new_words,
    ];
  }

  Future<void> nexPage(BuildContext context) async {
    if(pageController.page!.round() >= assets.length-1){
      _isLoading = true;
      notifyListeners();
      await Provider.of<MainProvider>(context, listen: false).setUserState(false);
      await Provider.of<MainProvider>(context, listen: false).logInAnon();
      Provider.of<MainProvider>(context, listen: false).getUserData();
      CustomNavigator.pushReplacement(context, const HomePage(),);
      // TODO: Activate this if need
      // ImageCache().clear();
    }else{
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.bounceOut);
    }
    notifyListeners();
  }
}