import 'dart:math';

import 'package:langquiz/models/quiz_model.dart';
import 'package:langquiz/providers/ads_provider.dart';
import 'package:langquiz/services/database.dart';
import 'package:langquiz/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../config/resource.dart';
import '../models/user_model.dart';
import '../models/word_model.dart';

class MainProvider extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<WordModel> _words = [];
  List<QuizModel> _quiz = [];
  String? level;

  List<WordModel> get words => _words;
  List<QuizModel> get quiz => _quiz;

  DocumentSnapshot? lastDoc;


  final List<String> levels = [
    "A1", "A2", "B1", "B2", "C1", "C2"
  ];

  final List<String> optionsChar = [
    "A", "B", "C", "D", "E",
  ];

  String? _selectedAnswer;
  set selectedAnswer(String? val) {
    _selectedAnswer = val;
    notifyListeners();
  }

  final PageController pageController = PageController();

  User? _firebaseUser;
  String? get user => _firebaseUser == null ? null: _firebaseUser!.uid;

  UserModel? _user;

  double get successRate => _user!.successRate!;

  bool? isNewUser;

  int _correctAnswers = 0;
  int _wrongAnswers = 0;

  Locale? _locale;
  Locale? get locale => _locale;
  void setDefaultLocale(val){
    _locale = val;
  }
  set locale(val) {
    _locale = val;
    notifyListeners();
  }

  int _errorsCount = 0;
  int _maxErrorsCount = 3;
  int get errorsCount => _errorsCount;
  int get maxErrorsCount => _maxErrorsCount;

  bool isWordSaving = false;
  // bool get isWordSaving => _isWordSaving;
  final List<String> welcomeAssets = [
    R.ASSETS_01_SVG,
    R.ASSETS_02_SVG,
    R.ASSETS_03_SVG,
  ];
  final List<String> otherAssets = [
    R.ASSETS_SETTINGS_SVG
  ];

  MainProvider(){
    getUserState().then((value) {
      if(value == null || value){
        loadSvgs(welcomeAssets);
      }else{
        getUserData();
        loadSvgs(otherAssets);
      }
      isNewUser = value;
      if(!(value??true)){
        notifyListeners();
      }
    });
    _auth.authStateChanges().listen((event) {
      _firebaseUser = event;
    });
  }

  @override
  dispose(){
    pageController.dispose();
    super.dispose();
  }


  Future loadSvgs(List<String> svgs)async{
    late Future result;
    for(int i = 0; i < svgs.length; i++){
      result = precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoderBuilder, svgs[i]), null);
    }
    return result;
  }

  /// ******** Auth functions start ********
  Future logInAnon () async{
    try{
      UserCredential _user = await _auth.signInAnonymously();
      await Database.id(_user.user!.uid).setNewUserData();
      return _user;
    }catch(e){
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  void getUserData(){
    if(_firebaseUser != null){
      try{
        Database.id(_firebaseUser!.uid).userData.listen((user) {
          _user = user;
        });
      }catch(e){
        if (kDebugMode) {
          print("getUserData $e");
        }
      }
    }
  }

  Future setUserState(bool state) async{
    final prefs = await SharedPreferences.getInstance();
    try{
      return prefs.setBool("isNewUser", state);
    }catch(e){
      if (kDebugMode) {
        print("Shared_preferences Error: $e");
      }
      rethrow;
    }
  }

  Future<bool?> getUserState() async{
    try{
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool("isNewUser");
    }catch(e){
      if (kDebugMode) {
        print("Shared_preferences Error: $e");
      }
      rethrow;
    }
  }
  /// ******** Auth functions end ********

  /// ******** Learning functions start ********
  void getLearningWords(BuildContext context) async{
    assert(level != null, "Level must not be null");
    _words = await Database
        .level(level, _firebaseUser!.uid, context)
        .allLearningWords;
    notifyListeners();
  }

  void getMoreLearningWords(BuildContext context) async{
    assert(level != null, "Level must not be null");
    _words = await Database
        .level(level, _firebaseUser!.uid, context)
        .allLearningWordsMore;
    if(_words.isEmpty){
      ScaffoldMessenger
          .of(context)
          .showSnackBar(
        SnackBar(
          content: CustomText(
            text: AppLocalizations.of(context)!.no_more,
            lang: _locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
          ),
        ),
      );
    }
    notifyListeners();
  }

  void saveLearnedWord(String docID, int learnedCount, int users) async{
    await Database.id(_firebaseUser!.uid).updateWordUsers(docID);
    await Database.id(_firebaseUser!.uid).updateLearnedWordsUser(docID, learnedCount, users);
  }

  void onAccept(int index){
    saveLearnedWord(_words[index].id!, _words[index].learnedUsers![_firebaseUser!.uid]??0, _words[index].learnedUsers!['users']??0);
    _words.removeAt(index);
    isWordSaving = false;
    notifyListeners();
  }
  /// ******** Learning functions end ********

  List<QuizModel> _convertWordsToQuiz(List<WordModel> _words){
    List<QuizModel> result = [];
    if(_words.length > 4){
      _words.shuffle();
      Random _ran = Random(0);
      for (var word in _words) {
        List<String> answers = [];
        int _ranInt = _ran.nextInt(_words.length - 4);
        for(int i = _ranInt; i < _words.length; i++){
          answers.add(_locale!.languageCode == 'ar' ? _words[i].arabic! : _words[i].turkish!);
          if(answers.length >= 5){
            break;
          }
        }
        if(!answers.contains(_locale!.languageCode == 'ar' ? word.arabic! : word.turkish!)){
          answers.remove(answers.last);
          answers.add(_locale!.languageCode == 'ar' ? word.arabic! : word.turkish!);
        }
        answers.shuffle();
        result.add(
          QuizModel(
            answers: answers,
            arabic: word.arabic,
            turkish: word.turkish,
            level: word.level,
            correctAnswer: _locale!.languageCode == 'ar' ? word.arabic! : word.turkish!,
          ),
        );
        if(result.length >= 10){
          break;
        }
      }
    }
    return result;
  }

  Map<String, String> levelsName(BuildContext context){
    final translate = AppLocalizations.of(context)!;
    return {
      "A1": translate.beginning, "A2": translate.basic, "B1": translate.pre_intermediate,
      "B2": translate.intermediate_level, "C1": translate.above_Intermediate, "C2": translate.further,
    };
  }

  /// ******** Quiz functions start ********
  void getQuiz(BuildContext context){
    assert(level != null, "Level must not be null");
    Database.level(level, _firebaseUser!.uid, context).allWords.listen((words) {
      _quiz = _convertWordsToQuiz(words);
      _quiz.shuffle();
      notifyListeners();
    });
  }

  Future customDialog(BuildContext mainContext, {bool isScoreDialog = true}) async{
    return await showDialog(
      context: mainContext,
      builder: (dialogContext){
        final AdsProvider ad = AdsProvider();
        return WillPopScope(
          onWillPop: () async{
            return false;
          },
          child: isScoreDialog ?
          scoreDialog(mainContext, dialogContext):
          ChangeNotifierProvider<AdsProvider>(
              create: (_)=> ad,
              builder: (context, _){
                return offerDialog(mainContext, context);
              },
            ),
        );
      },
    );
  }

  Future chooseAnswer(BuildContext mainContext, int pageIndex, int listIndex) async{
    bool _isNotMax = true;
    _selectedAnswer = _quiz[pageIndex].answers![listIndex];
    notifyListeners();
    if(isRightAnswer(pageIndex, listIndex)??false){
      _correctAnswers++;
    }
    else{
      _wrongAnswers++;
      _errorsCount++;
      _isNotMax = _errorsCount+1 <= _maxErrorsCount;
    }
    if(pageController.page!.round() < _quiz.length-1) {
      if(_isNotMax){
        await Future.delayed(
          const Duration(milliseconds: 250),
              () {
            _selectedAnswer = null;
            notifyListeners();
          },
        );
        await pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.bounceIn,
        );
        _quiz[pageIndex].answers!.shuffle();
        notifyListeners();
      }else{
        customDialog(mainContext, isScoreDialog: false);
      }

    }
    else{
      // End of quiz
      customDialog(mainContext);
    }

  }

  AlertDialog scoreDialog(BuildContext mainContext, dialogContext){
    final translate = AppLocalizations.of(mainContext)!;
    double _score = _correctAnswers.toDouble() * 100.0;
    return AlertDialog(
      title: Center(
        child: CustomText(
          text: translate.score,
          lang: _locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: "${translate.correct_answers}: $_correctAnswers",
            lang: _locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
          ),
          CustomText(
            text: "${translate.wrong_answers}: $_wrongAnswers",
            lang: _locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
          ),
          CustomText(
            text: "${translate.score}: $_score",
            lang: _locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: (){
            Database.id(_firebaseUser!.uid).updateUserData(_user!.successRate! + _score);
            Navigator.of(dialogContext).pop();
            Navigator.of(mainContext).pop();
            _selectedAnswer = null;
            _correctAnswers = 0;
            _wrongAnswers = 0;
            _errorsCount = 0;
            _maxErrorsCount = 3;
          },
          child: CustomText(
            text: translate.terminate,
            lang: _locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
          ),
        ),
      ],
    );
  }

  AlertDialog offerDialog(BuildContext mainContext, dialogContext){
    final translate = AppLocalizations.of(mainContext)!;
    return AlertDialog(
      title: Center(
        child: CustomText(
          text: "هل تريد المتابعة؟",
          lang: _locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: "شاهد فيديو لإضافة محاول اخرى",
            lang: _locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Provider.of<AdsProvider>(dialogContext).isAdLoading?
        const CircularProgressIndicator():TextButton(
          onPressed: ()async{
            Provider.of<AdsProvider>(dialogContext, listen: false).getAd(dialogContext);
            // Navigator.of(dialogContext).pop();
          },
          child: CustomText(
            text: "مشاهدة",
            lang: _locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
          ),
        ),
        TextButton(
          onPressed: (){
            Navigator.of(dialogContext).pop();
            Navigator.of(mainContext).pop();
            _selectedAnswer = null;
            _correctAnswers = 0;
            _wrongAnswers = 0;
            _errorsCount = 0;
            _maxErrorsCount = 3;
          },
          child: CustomText(
            text: translate.terminate,
            lang: _locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
          ),
        ),
      ],
    );
  }

  void handleReward(num rewardAmount, BuildContext context){
    if(rewardAmount > 0){
      _maxErrorsCount++;
      Navigator.of(context).pop();
    }
    notifyListeners();
  }

  bool? isSelected(int pageIndex, int listIndex) {
    return _selectedAnswer == null ? null : _quiz[pageIndex].answers![listIndex] == _selectedAnswer;
  }

  bool? isRightAnswer(int pageIndex, int listIndex){
    return _quiz[pageIndex].answers![listIndex] == (_locale!.languageCode == 'ar' ? _quiz[pageIndex].arabic : _quiz[pageIndex].turkish) && _selectedAnswer==(_locale!.languageCode == 'ar' ? _quiz[pageIndex].arabic : _quiz[pageIndex].turkish);
  }

  Future<bool> willPop(BuildContext context) async{
    final translate = AppLocalizations.of(context)!;
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomText(
            text: translate.end_quiz,
            lang: _locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
          ),
          content: CustomText(
            text: "${translate.if_you_end_quiz_your_score_will_gone}\n${translate.do_you_want_to_end_quiz}",
            lang: _locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
          ),
          actions: [
            TextButton(
              onPressed: ()=> Navigator.of(context).pop(false),
              child: CustomText(
                text: translate.no,
                lang: _locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                _selectedAnswer = null;
                _correctAnswers = 0;
                _wrongAnswers = 0;
                _errorsCount = 0;
                _maxErrorsCount = 3;
              },
              child: CustomText(
                text: translate.yes,
                lang: _locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
              ),
            ),
          ],
        );
      },
    ) ?? false;
  }
  /// ******** Quiz functions end ********
}