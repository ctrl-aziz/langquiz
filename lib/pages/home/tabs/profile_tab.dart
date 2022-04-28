import 'package:langquiz/config/resource.dart';
import 'package:langquiz/providers/main_provider.dart';
import 'package:langquiz/services/database.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../widgets/custom_text.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;
    final _provider = Provider.of<MainProvider>(context);
    return Column(
      children: [
        const SizedBox(
          height: 50.0,
        ),
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey,
          backgroundImage: Svg(
            R.ASSETS_M_03_SVG,
          ),
        ),
        const SizedBox(height: 10.0,),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 110,
            animation: true,
            animationDuration: 1000,
            lineHeight: 20.0,
            leading: CustomText(
              text: "${translate.success_rate}:",
              lang: Provider.of<MainProvider>(context).locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
            ),
            percent: (_provider.successRate >= 100000.0 ? 100000.0 : _provider.successRate) / 100000.0,
            center: CustomText(
              text: "${_provider.successRate}",
              lang: Provider.of<MainProvider>(context).locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
              fontSize: 17,
            ),
            barRadius: const Radius.circular(20.0),
            progressColor: Colors.red,
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 15.0,),
            FutureBuilder<int>(
              future: Database.id(_provider.user).userLearnedWords,
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return CustomText(
                    text: translate.error_Set_01_,
                    lang: Provider.of<MainProvider>(context).locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
                    maxLines: 10,
                  );
                }
                return CustomText(
                  text: "${translate.earned_words}: ${snapshot.data??0}",
                  lang: Provider.of<MainProvider>(context).locale!.languageCode == 'ar' ? Lang.ar : Lang.tr,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
