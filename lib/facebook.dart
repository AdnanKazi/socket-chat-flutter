// import 'package:facebook_audience_network/ad/ad_banner.dart';
// import 'package:facebook_audience_network/ad/ad_interstitial.dart';
// import 'package:facebook_audience_network/ad/ad_rewarded.dart';
// import 'package:facebook_audience_network/facebook_audience_network.dart';
// import 'package:flutter/material.dart';

// class AdsPage extends StatefulWidget {
//   @override
//   AdsPageState createState() => AdsPageState();
// }

// class AdsPageState extends State<AdsPage> {
//   bool _isInterstitialAdLoaded = false;
//   bool _isRewardedAdLoaded = false;
//   bool _isRewardedVideoComplete = false;

//   /// All widget ads are stored in this variable. When a button is pressed, its
//   /// respective ad widget is set to this variable and the view is rebuilt using
//   /// setState().
//   Widget _currentAd = SizedBox(
//     width: 0.0,
//     height: 0.0,
//   );

//   @override
//   void initState() {
//     super.initState();

//     FacebookAudienceNetwork.init(
//       testingId: "b9f2908b-1a6b-4a5b-b862-ded7ce289e41",
//     );

//     _loadInterstitialAd();
//     _loadRewardedVideoAd();
//   }

//   void _loadInterstitialAd() {
//     FacebookInterstitialAd.loadInterstitialAd(
//       placementId:
//           "IMG_16_9_APP_INSTALL#195658622360577_195659995693773", //"IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617" YOUR_PLACEMENT_ID
//       listener: (result, value) {
//         print(">> FAN > Interstitial Ad: $result --> $value");
//         if (result == InterstitialAdResult.LOADED)
//           _isInterstitialAdLoaded = true;

//         /// Once an Interstitial Ad has been dismissed and becomes invalidated,
//         /// load a fresh Ad by calling this function.
//         if (result == InterstitialAdResult.DISMISSED &&
//             value["invalidated"] == true) {
//           _isInterstitialAdLoaded = false;
//           _loadInterstitialAd();
//         }
//       },
//     );
//   }

//   void _loadRewardedVideoAd() {
//     FacebookRewardedVideoAd.loadRewardedVideoAd(
//       placementId: "IMG_16_9_APP_INSTALL#195658622360577_195659995693773",
//       listener: (result, value) {
//         print("Rewarded Ad: $result --> $value");
//         if (result == RewardedVideoAdResult.LOADED) _isRewardedAdLoaded = true;
//         if (result == RewardedVideoAdResult.VIDEO_COMPLETE)
//           _isRewardedVideoComplete = true;

//         /// Once a Rewarded Ad has been closed and becomes invalidated,
//         /// load a fresh Ad by calling this function.
//         if (result == RewardedVideoAdResult.VIDEO_CLOSED &&
//             (value == true || value["invalidated"] == true)) {
//           _isRewardedAdLoaded = false;
//           _loadRewardedVideoAd();
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         Flexible(
//           child: Align(
//             alignment: Alignment(0, -1.0),
//             child: Padding(
//               padding: EdgeInsets.all(16),
//               child: _getAllButtons(),
//             ),
//           ),
//           fit: FlexFit.tight,
//           flex: 2,
//         ),
//         // Column(children: <Widget>[
//         //   _nativeAd(),
//         //   // _nativeBannerAd(),
//         //   _nativeAd(),
//         // ],),
//         Flexible(
//           child: Align(
//             alignment: Alignment(0, 1.0),
//             child: _currentAd,
//           ),
//           fit: FlexFit.tight,
//           flex: 3,
//         )
//       ],
//     );
//   }

//   Widget _getAllButtons() {
//     return _getRaisedButton(title: "Banner Ad", onPressed: _showBannerAd);
//   }

//   Widget _getRaisedButton({String title, void Function() onPressed}) {
//     return Padding(
//       padding: EdgeInsets.all(8),
//       child: RaisedButton(
//         onPressed: onPressed,
//         child: Text(
//           title,
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }

//   _showBannerAd() {
//     setState(() {
//       _currentAd = FacebookBannerAd(
//         placementId:
//             "IMG_16_9_APP_INSTALL#195658622360577_195659995693773", //testid
//         bannerSize: BannerSize.STANDARD,
//         listener: (result, value) {
//           print("Banner Ad: $result -->  $value");
//         },
//       );
//     });
//   }
// }
