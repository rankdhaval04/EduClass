import 'dart:async';
import 'dart:convert';

import 'package:ads/ads.dart';
import 'package:education/urlconfig.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/loader/gf_loader.dart';
import 'package:getflutter/types/gf_loader_type.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'mixin.dart';

class streamPage extends StatefulWidget {
  final String videoid;
  final bool islive;
  streamPage(this.videoid, this.islive);
  @override
  _streamPageState createState() => _streamPageState(this.videoid, this.islive);
}

class _streamPageState extends State<streamPage>
    with PortraitStatefulModeMixin<streamPage>{
  final String videoid;
  final bool islive;
  _streamPageState(this.videoid, this.islive);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final Completer<WebViewController> __controller = Completer<WebViewController>();
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;
  bool calling = true;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volum = 100;
  bool _muted = false;
  bool _isPlayerReady = false;


  Ads appAds;
  int _coins = 0;
  Widget view = GFLoader(type:GFLoaderType.circle);
  Widget viewafter;



  final String appId = Platform.isAndroid
      ? 'ca-app-pub-1077587831782371~1038969210'
      : 'ca-app-pub-1077587831782371~1038969210';

  final String bannerUnitId = Platform.isAndroid
      ? 'ca-app-pub-1077587831782371/7089372248'
      : 'ca-app-pub-1077587831782371/7089372248';

  final String screenUnitId = Platform.isAndroid
      ? 'ca-app-pub-1077587831782371/9847397528'
      : 'ca-app-pub-1077587831782371/9847397528';

  final String videoUnitId = Platform.isAndroid
      ? 'ca-app-pub-1077587831782371/2645008004'
      : 'ca-app-pub-1077587831782371/2645008004';


  @override
  void initState() {
    super.initState();

        _controller = YoutubePlayerController(
          initialVideoId: videoid,//_ids.first,
          flags: YoutubePlayerFlags(
            mute: false,
            autoPlay: false,
            disableDragSeek: false,
            loop: false,
            isLive: islive,
            forceHD: false,
            enableCaption: true,
          ),
        )..addListener(listener);
        _idController = TextEditingController();
        _seekToController = TextEditingController();
        _videoMetaData = YoutubeMetaData();
        _playerState = PlayerState.unknown;
    setState(() {
      calling = false;
    });


    /// Assign a listener.
    var eventListener = (MobileAdEvent event) {
      if (event == MobileAdEvent.opened) {
        print("eventListener: The opened ad is clicked on.");
      }
    };

    appAds = Ads(
      appId,
      bannerUnitId: bannerUnitId,
      screenUnitId: screenUnitId,
      keywords: ['Game', 'Pubg', 'Freefire', 'cars', 'android', 'apple', 'mobile', 'phone', 'sudoku'],
      contentUrl: 'http://www.ibm.com',
      childDirected: true,
      testing: false,
      listener: eventListener,
    );

    appAds.setVideoAd(
      adUnitId: videoUnitId,
      keywords: ['Game', 'Pubg', 'Freefire', 'cars', 'android', 'apple', 'mobile', 'phone', 'sudoku'],
      contentUrl: 'http://www.publang.org',
      childDirected: true,
      testing: false,
      listener: (RewardedVideoAdEvent event,
          {String rewardType, int rewardAmount}) {
        print("The ad was sent a reward amount.");
        setState(() {
          _coins += rewardAmount;
        });
      },
    );

    appAds.showBannerAd();
    appAds.showBannerAd(state: this);
    appAds.showFullScreenAd(state: this);
    appAds.showVideoAd(state: this);


  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    appAds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
//      appBar: AppBar(
////        leading: Padding(
////          padding: const EdgeInsets.only(left: 12.0),
////          child: Image.asset(
////            'assets/ypf.png',
////            fit: BoxFit.fitWidth,
////          ),
////        ),
////        title: Text(
////          'Learn',
////          style: TextStyle(color: Colors.white),
////        ),
////        actions: [
////          IconButton(
////            icon: Icon(Icons.video_library),
////            onPressed: () => Navigator.push(
////              context,
////              CupertinoPageRoute(
////                builder: (context) => VideoList(),
////              ),
////            ),
////          ),
////        ],
//      ),
      body: ListView(
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            topActions: <Widget>[
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  _controller.metadata.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 25.0,
                ),
                onPressed: () {
                  _showSnackBar('');
                },
              ),
            ],
            onReady: () {
              _isPlayerReady = true;
            },
          ),

          Container(
            height: 500.0,
            child: WebView(
              initialUrl:"https://docs.google.com/forms/d/e/1FAIpQLScUKQaQ4OZYMYOm807TVz2WpQTwxy5pFY5zN08a4J3YVTaOtw/viewform?usp=sf_link",
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                __controller.complete(webViewController);
              },
            ),
          ),
        ],
      ),
    );
  }


  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}
