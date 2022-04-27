import 'package:langquiz/providers/main_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

const int maxFailedLoadAttempts = 3;
class AdsProvider extends ChangeNotifier{
  RewardedAd? _rewardedAd;
  bool _isAdLoading = false;
  bool get isAdLoading => _isAdLoading;
  final String unitID = 'ca-app-pub-2166356757208745/7639865410';

  @override
  void dispose() {
    super.dispose();
    if(_rewardedAd != null){
      _rewardedAd!.dispose();
    }
  }

  void _createRewardedAd(BuildContext context) {
    _isAdLoading = true;
    notifyListeners();
    try{
      RewardedAd.load(
          adUnitId: unitID,
          request: const AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              if (kDebugMode) {
                print('$ad loaded.');
              }
              _rewardedAd = ad;
              _isAdLoading = false;
              notifyListeners();
              _showRewardedAd(context);
            },
            onAdFailedToLoad: (LoadAdError error) {
              if (kDebugMode) {
                print('RewardedAd failed to load: $error');
              }
              _rewardedAd = null;
              _isAdLoading = false;
              notifyListeners();
            },
          ));
    }catch(e){
      if (kDebugMode) {
        print("_createRewardedAd Error: $e");
      }
    }
  }

  void _showRewardedAd(BuildContext context) {
    num _reward = 0;
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        if (kDebugMode) {
          print('$ad onAdDismissedFullScreenContent.');
        }
        try{
          Provider.of<MainProvider>(context, listen: false).handleReward(_reward, context);
        }catch(e){
          if (kDebugMode) {
            print("Provider Errorr: $e");
          }
        }
        ad.dispose();
      },
    );
    try{
      _rewardedAd!.setImmersiveMode(true);
      _rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
            if (kDebugMode) {
              print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
            }
            _reward = reward.amount;
          });
    }catch(e){
      if (kDebugMode) {
        print("showRewardedAd Error: $e");
      }
    }
    _rewardedAd = null;
  }

  void getAd(BuildContext context) => _rewardedAd == null ? _createRewardedAd(context) : _showRewardedAd(context);
}