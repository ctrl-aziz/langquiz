import 'package:langquiz/config/resource.dart';
import 'package:langquiz/providers/splash_provider.dart';
import 'package:langquiz/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/main_provider.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<SplashProvider>(
        create: (_) => SplashProvider(),
        builder: (context, _){
          return Consumer<SplashProvider>(
            builder: (context, splash, _){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 7,
                    child: PageView.builder(
                      controller: splash.pageController,
                      itemCount: splash.assets.length,
                      itemBuilder: (context, i){
                        return splash.isLoading ?
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 150,
                                height: 150,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(.2),
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 3,
                                        spreadRadius: 7,
                                        color: Colors.white,

                                      ),
                                    ]
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(R.ASSETS_LOGO_PNG),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0,),
                              CustomText(
                                text: "Langquiz",
                                lang: Lang.tr,
                                fontWeight: FontWeight.bold,
                                fontSize: 27,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(height: 10.0,),
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  color: Colors.grey[400],
                                ),
                              ),
                              const SizedBox(height: 15.0,),
                              CustomText(
                                text: AppLocalizations.of(context)!.loading,
                                lang: Provider.of<MainProvider>(context).locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ],
                          ),
                        ) :
                          Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SvgPicture.asset(splash.assets[i]),
                            // Oswald
                            // Dancing Script
                            Flexible(
                              child: CustomText(
                                text: splash.titles(context)[i],
                                lang: Provider.of<MainProvider>(context).locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
                                fontSize: 25,
                                maxLines: 5,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  splash.isLoading ?
                  const SizedBox(width: 50, height: 50,) :
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: () async {
                        await splash.nexPage(context);
                      },
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          GoogleFonts.oswald(),
                        ),
                        foregroundColor: MaterialStateProperty.all(
                            Colors.red
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          splash.isLastPage ?
                          CustomText(
                            text: AppLocalizations.of(context)!.start,
                            lang: Provider.of<MainProvider>(context).locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
                          ) :
                          CustomText(
                            text: AppLocalizations.of(context)!.next,
                            lang: Provider.of<MainProvider>(context).locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
                          ),
                          splash.isLastPage
                              ? const SizedBox():const Icon(Icons.arrow_forward_ios),
                          const SizedBox(width: 10.0,),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
