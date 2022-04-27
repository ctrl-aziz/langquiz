import 'package:langquiz/config/resource.dart';
import 'package:langquiz/providers/main_provider.dart';
import 'package:langquiz/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;
    final String langCode = Provider.of<MainProvider>(context).locale!.languageCode;
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: translate.settings,
          lang: langCode == 'ar' ? Lang.ar : Lang.tr,
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: SvgPicture.asset(
              R.ASSETS_SETTINGS_SVG,
              color: Colors.grey[400],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(text: translate.language, lang: Lang.ar),
              const SizedBox(width: 20.0,),
              DropdownButton<String>(
                value: langCode == 'ar' ? "عربي" : "Türkçe",
                items: const [
                  DropdownMenuItem<String>(
                    value: "عربي",
                    child: CustomText(
                      text: "عربي",
                      lang: Lang.ar,
                      fontSize: 15,
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: "Türkçe",
                    child: CustomText(
                      text: "Türkçe",
                      lang: Lang.tr,
                      fontSize: 15,
                    ),
                  )
                ],
                onChanged: (val){
                  switch(val){
                    case "عربي":
                      Provider.of<MainProvider>(context, listen: false).locale = const Locale("ar");
                      break;
                    case "Türkçe":
                      Provider.of<MainProvider>(context, listen: false).locale = const Locale("tr");
                      break;
                    default:
                      Provider.of<MainProvider>(context, listen: false).locale = const Locale("ar");
                      break;
                  }
                },
              ),
            ],
          ),
          Column(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomText(
                      text: translate.problem_report,
                      lang: langCode == 'ar' ? Lang.ar : Lang.tr,
                      fontSize: 17,
                    ),
                  ),
              ),
              Column(
                children: [
                  CustomText(
                    text: translate.gmail,
                    lang: langCode == 'ar' ? Lang.ar : Lang.tr,
                    fontSize: 17,
                  ),
                  IconButton(
                    onPressed: (){
                      // TODO: Change email to admin email
                      final Uri _emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: 'contact@langquiz.tk',
                          queryParameters: {
                            'subject': ''
                          }
                      );
                      launch(_emailLaunchUri.toString());
                    },
                    icon: const Icon(Icons.mail, size: 50, color: Color(0xffFF6A6B),),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
