import 'package:langquiz/pages/settings_page.dart';
import 'package:langquiz/providers/main_provider.dart';
import 'package:langquiz/widgets/custom_navigator.dart';
import 'package:langquiz/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'tabs/learn_tab.dart';
import 'tabs/profile_tab.dart';
import 'tabs/quiz_tab.dart';

/*
  * #267DB2
  * #FF6A6B
  * #50BCFF
  * #CCCA2C
  * #B2B02F
  * */
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<String> titles(BuildContext context) {
    final translate = AppLocalizations.of(context)!;
    return [
      translate.learn,
      translate.quiz,
      translate.profile,
    ];
  }

  int _currentIndex = 0;

  @override
  void initState() {
    login();
    super.initState();
    _tabController = TabController(vsync: this, length: 3)..addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  login() async {
    if(Provider.of<MainProvider>(context, listen: false).user == null) {
      await Provider.of<MainProvider>(context, listen: false).logInAnon();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: titles(context)[_currentIndex],
            lang: Provider.of<MainProvider>(context).locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
            color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: (){
              CustomNavigator.push(context, const SettingsPage());
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 10.0,),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          LearnTab(),
          QuizTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: Container(
        color: const Color(0xff267DB2),
        child: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xffFF6A6B),
          labelColor: const Color(0xffFF6A6B),
          overlayColor: MaterialStateProperty.all(Colors.black),
          unselectedLabelColor: Colors.white,
          tabs: List.generate(
            titles(context).length,
                (index) => Tab(
            child: CustomText(
              text: titles(context)[index],
              lang: Provider.of<MainProvider>(context).locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
              fontSize: 14,
            ),
          ),
          ),
        ),
      ),
    );
  }
}
