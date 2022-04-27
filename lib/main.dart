import 'package:langquiz/pages/home/home_page.dart';
import 'package:langquiz/pages/welcome_page.dart';
import 'package:langquiz/providers/main_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'config/resource.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.grey[300],
        )
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MainProvider>(create: (_) => MainProvider()),
      ],
      builder: (context, _){
        bool? _isNewUser = Provider.of<MainProvider>(context).isNewUser;
        if (kDebugMode) {
          print("User id: ${Provider.of<MainProvider>(context).user}");
        }
        return MaterialApp(
          title: 'Arapça Quiz',
          localeListResolutionCallback: (locales, supportedLocales){
            if(supportedLocales.where((supportedLocale) => supportedLocale.languageCode == locales!.first.languageCode).length == 1){
              Provider.of<MainProvider>(context, listen: false).setDefaultLocale(Locale(locales!.first.languageCode));
              return Locale(locales.first.languageCode);
            }
            else{
              Provider.of<MainProvider>(context, listen: false).setDefaultLocale(const Locale('ar', ));
              return const Locale('ar', );
            }

          },
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar', ''), // Arabic, no country code
            Locale('tr', ''), // Turkish, no country code
          ],
          locale: Provider.of<MainProvider>(context).locale,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: TextTheme(
                bodyText1: GoogleFonts.oswald(),
                bodyText2: GoogleFonts.oswald()
            ),
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.grey[300],
                foregroundColor: const Color(0xff267DB2),
                centerTitle: true,
                iconTheme: const IconThemeData(
                  color: Color(0xff267DB2),
                  size: 27,
                )
            ),
            scaffoldBackgroundColor: Colors.grey[300],
          ),
          home: AnimatedSplashScreen(
            splash: Image.asset(R.ASSETS_LOGO_ROUND_PNG),
            splashIconSize: 100.0,
            backgroundColor: Colors.grey[300]!,
            splashTransition: SplashTransition.slideTransition,
            pageTransitionType: PageTransitionType.rightToLeft,
            nextScreen: _isNewUser == null || _isNewUser ? const WelcomePage() : const HomePage(),
          ),
        );
      },
    );
  }


}
