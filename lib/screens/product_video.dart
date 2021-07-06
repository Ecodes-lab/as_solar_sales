import 'package:as_solar_sales/helpers/style.dart';
import 'package:as_solar_sales/widgets/custom_text.dart';
import 'package:as_solar_sales/widgets/video_items.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

// void main() => runApp(VideoApp());

class ProductVideoScreen extends StatelessWidget {
  VideoItems _chewieController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: CustomText(text: "AS Video", color: Colors.white,),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: Colors.black.withOpacity(0.89),
      body: Center(
        child: VideoItems(
          videoPlayerController: VideoPlayerController.network(
              'https://firebasestorage.googleapis.com/v0/b/as-solar-sales-16fd7.appspot.com/o/UKGermany%20advert.MP4?alt=media&token=ecc6313d-9fdc-42af-aa8f-f69f846dfb5e'),
          looping: false,
          autoplay: true,
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       _controller.value.isPlaying
      //           ? _controller.pause()
      //           : _controller.play();
      //     });
      //   },
      //   child: Icon(
      //     _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
      //   ),
      // ),
    );
  }
}


// class ProductVideoScreen extends StatefulWidget {
//   @override
//   _ProductVideoScreenState createState() => _ProductVideoScreenState();
// }
//
// class _ProductVideoScreenState extends State<ProductVideoScreen> {
//   VideoPlayerController _controller;
//
//   // Future<ClosedCaptionFile> _loadCaptions() async {
//   //   final String fileContents = await DefaultAssetBundle.of(context)
//   //       .loadString('assets/bumble_bee_captions.srt');
//   //   return SubRipCaptionFile(fileContents);
//   // }
//
//   @override
//   void initState() {
//     super.initState();
//     // _controller = VideoPlayerController.network(
//     //     'https://firebasestorage.googleapis.com/v0/b/as-solar-sales-16fd7.appspot.com/o/UKGermany%20advert.MP4?alt=media&token=ecc6313d-9fdc-42af-aa8f-f69f846dfb5e');
//     //   ..initialize().then((_) {
//     //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//     //     setState(() {});
//     //   }
//     _controller = VideoPlayerController.network(
//       'https://firebasestorage.googleapis.com/v0/b/as-solar-sales-16fd7.appspot.com/o/UKGermany%20advert.MP4?alt=media&token=ecc6313d-9fdc-42af-aa8f-f69f846dfb5e',
//       // closedCaptionFile: _loadCaptions(),
//       videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
//     );
//
//     _controller.addListener(() {
//       setState(() {});
//     });
//     _controller.setLooping(true);
//     _controller.initialize();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           iconTheme: IconThemeData(color: white),
//           backgroundColor: Colors.black,
//           elevation: 0.0,
//           title: CustomText(text: "AS Video", color: Colors.white,),
//           leading: IconButton(
//               icon: Icon(Icons.close),
//               onPressed: () {
//                 Navigator.pop(context);
//               }),
//         ),
//         backgroundColor: Colors.black.withOpacity(0.89),
//         body: Center(
//           child: _controller.value.isInitialized
//               ? AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             // child: VideoPlayer(_controller),
//             child: Stack(
//               alignment: Alignment.bottomCenter,
//               children: <Widget>[
//                 VideoItems(
//                   videoPlayerController: _controller,
//                   looping: true,
//                   autoplay: true,
//                 ),
//                 // VideoPlayer(_controller),
//                 // ClosedCaption(text: _controller.value.caption.text),
//                 // _ControlsOverlay(controller: _controller),
//                 // VideoProgressIndicator(_controller, allowScrubbing: true),
//               ],
//             ),
//           )
//               : Container(),
//         ),
//         // floatingActionButton: FloatingActionButton(
//         //   onPressed: () {
//         //     setState(() {
//         //       _controller.value.isPlaying
//         //           ? _controller.pause()
//         //           : _controller.play();
//         //     });
//         //   },
//         //   child: Icon(
//         //     _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         //   ),
//         // ),
//       );
//     // );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key key, this.controller}) : super(key: key);

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (context) {
              return [
                for (final speed in _examplePlaybackRates)
                  PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}



// import 'dart:developer';
//
// import 'package:as_solar_sales/helpers/style.dart';
// import 'package:as_solar_sales/widgets/custom_text.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// // import 'video_list.dart';
//
// // void main() {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   SystemChrome.setSystemUIOverlayStyle(
// //     const SystemUiOverlayStyle(
// //       statusBarColor: Colors.blueAccent,
// //     ),
// //   );
// //   runApp(YoutubePlayerDemoApp());
// // }
//
// /// Creates [YoutubePlayerPage] widget.
// class YoutubePlayerPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//
//     // YoutubePlayerController _controller = YoutubePlayerController(
//     //   initialVideoId: 'W_55ELF-_FY',
//     //   flags: YoutubePlayerFlags(
//     //     hideControls: false,
//     //     controlsVisibleAtStart: true,
//     //     autoPlay: true,
//     //     mute: false,
//     //   ),
//     // );
//     //
//     // String videoId;
//     // videoId = YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=W_55ELF-_FY");
//
//     return Scaffold(
//         appBar: AppBar(
//           iconTheme: IconThemeData(color: white),
//           backgroundColor: Colors.black,
//           elevation: 0.0,
//           title: CustomText(text: "AS Video", color: Colors.white,),
//           leading: IconButton(
//               icon: Icon(Icons.close),
//               onPressed: () {
//                 Navigator.pop(context);
//               }),
//         ),
//         backgroundColor: Colors.black.withOpacity(0.89),
//         body: SafeArea(
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child:
//               // YoutubePlayerBuilder(
//               //   player: YoutubePlayer(
//               //     controller: _controller,
//               //   ),
//               //   builder: (context, player) {
//               //     return Column(
//               //       children: [
//               //         // some widgets
//               //         player,
//               //         //some other widgets
//               //       ],
//               //     );
//               //   },
//               // ),
//               YoutubePlayer(
//                 controller: YoutubePlayerController(
//                   initialVideoId: "W_55ELF-_FY", //Add videoID.
//                   flags: YoutubePlayerFlags(
//                     forceHD: false,
//                     hideControls: false,
//                     controlsVisibleAtStart: true,
//                     autoPlay: true,
//                     mute: false,
//                   ),
//                 ),
//                 // bottomActions: [
//                   // CurrentPosition(),
//                   // ProgressBar(isExpanded: true),
//                   // TotalDuration(),
//                 // ],
//                 // liveUIColor: Colors.amber,
//                 showVideoProgressIndicator: true,
//                 progressIndicatorColor: green,
//                   // videoProgressIndicatorColor: Colors.amber,
//                   // progressColors: ProgressColors(
//                   //   playedColor: Colors.amber,
//                   //   handleColor: Colors.amberAccent,
//                   // ),
//                 // onReady () {
//                 //   controller.addListener(listener);
//                 // },
//               ),
//             ),
//           ),
//         )
//     );
//     // return MaterialApp(
//     //   debugShowCheckedModeBanner: false,
//     //   title: 'Youtube Player Flutter',
//     //   theme: ThemeData(
//     //     primarySwatch: Colors.blue,
//     //     appBarTheme: const AppBarTheme(
//     //       color: Colors.blueAccent,
//     //       textTheme: TextTheme(
//     //         headline6: TextStyle(
//     //           color: Colors.white,
//     //           fontWeight: FontWeight.w300,
//     //           fontSize: 20.0,
//     //         ),
//     //       ),
//     //     ),
//     //     iconTheme: const IconThemeData(
//     //       color: Colors.blueAccent,
//     //     ),
//     //   ),
//     //   home: YoutubePlayer(
//     //     controller: YoutubePlayerController(
//     //       initialVideoId: 'W_55ELF-_FY', //Add videoID.
//     //       flags: YoutubePlayerFlags(
//     //         forceHD: true,
//     //         hideControls: false,
//     //         controlsVisibleAtStart: true,
//     //         autoPlay: true,
//     //         mute: false,
//     //       ),
//     //     ),
//     //     showVideoProgressIndicator: true,
//     //     progressIndicatorColor: green,
//     //   ),
//     // );
//   }
// }

// class ProductVideoScreen extends StatefulWidget {
//   // const ProductVideoScreen({Key? key}) : super(key: key);
//
//   @override
//   _ProductVideoScreenState createState() => _ProductVideoScreenState();
// }
//
// class _ProductVideoScreenState extends State<ProductVideoScreen> {
//   YoutubePlayerController _controller;
//   TextEditingController _idController;
//   TextEditingController _seekToController;
//
//   PlayerState _playerState;
//   YoutubeMetaData _videoMetaData;
//   double _volume = 100;
//   bool _muted = false;
//   bool _isPlayerReady = false;
//
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = YoutubePlayerController(
//       initialVideoId: "W_55ELF-_FY",
//       flags: const YoutubePlayerFlags(
//         mute: false,
//         autoPlay: true,
//         disableDragSeek: false,
//         loop: false,
//         isLive: false,
//         forceHD: false,
//         enableCaption: true,
//       ),
//     )..addListener(listener);
//     _idController = TextEditingController();
//     _seekToController = TextEditingController();
//     _videoMetaData = const YoutubeMetaData();
//     _playerState = PlayerState.unknown;
//   }
//
//   void listener() {
//     if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
//       setState(() {
//         _playerState = _controller.value.playerState;
//         _videoMetaData = _controller.metadata;
//       });
//     }
//   }
//
//   @override
//   void deactivate() {
//     // Pauses video while navigating to next page.
//     _controller.pause();
//     super.deactivate();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _idController.dispose();
//     _seekToController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: white),
//         backgroundColor: Colors.black,
//         elevation: 0.0,
//         title: CustomText(text: "AS Video", color: Colors.white,),
//         leading: IconButton(
//             icon: Icon(Icons.close),
//             onPressed: () {
//               Navigator.pop(context);
//             }),
//       ),
//       backgroundColor: Colors.black.withOpacity(0.89),
//       body: SafeArea(
//         child: YoutubePlayerBuilder(
//           onExitFullScreen: () {
//             // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
//             SystemChrome.setPreferredOrientations(DeviceOrientation.values);
//           },
//           player: YoutubePlayer(
//             controller: _controller,
//             showVideoProgressIndicator: true,
//             progressIndicatorColor: Colors.blueAccent,
//             topActions: <Widget>[
//               const SizedBox(width: 8.0),
//               Expanded(
//                 child: Text(
//                   _controller.metadata.title,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18.0,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 1,
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(
//                   Icons.settings,
//                   color: Colors.white,
//                   size: 25.0,
//                 ),
//                 onPressed: () {
//                   log('Settings Tapped!');
//                 },
//               ),
//             ],
//             onReady: () {
//               _isPlayerReady = true;
//             },
//             // onEnded: (data) {
//             //   _controller
//             //       .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
//             //   _showSnackBar('Next Video Started!');
//             // },
//           ),
//           builder: (context, player) {
//             return Column(
//               children: [
//                 // some widgets
//                 player,
//                 //some other widgets
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             fontWeight: FontWeight.w300,
//             fontSize: 16.0,
//           ),
//         ),
//         backgroundColor: Colors.blueAccent,
//         behavior: SnackBarBehavior.floating,
//         elevation: 1.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(50.0),
//         ),
//       ),
//     );
//   }
// }



// class ProductVideoScreen extends StatefulWidget {
//   @override
//   _ProductVideoScreenState createState() => _ProductVideoScreenState();
// }
//
// class _ProductVideoScreenState extends State<ProductVideoScreen> {
//   YoutubePlayerController _controller;
//   TextEditingController _idController;
//   TextEditingController _seekToController;
//
//   PlayerState _playerState;
//   YoutubeMetaData _videoMetaData;
//   double _volume = 100;
//   bool _muted = false;
//   bool _isPlayerReady = false;
//
//   final List<String> _ids = [
//     'nPt8bK2gbaU',
//     'gQDByCdjUXw',
//     'iLnmTe5Q2Qw',
//     '_WoCV4c6XOE',
//     'KmzdUe0RSJo',
//     '6jZDSSZZxjQ',
//     'p2lYr3vM_1w',
//     '7QUtEmBT_-w',
//     '34_PXCzGw1M',
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = YoutubePlayerController(
//       initialVideoId: _ids.first,
//       flags: const YoutubePlayerFlags(
//         mute: false,
//         autoPlay: true,
//         disableDragSeek: false,
//         loop: false,
//         isLive: false,
//         forceHD: false,
//         enableCaption: true,
//       ),
//     )..addListener(listener);
//     _idController = TextEditingController();
//     _seekToController = TextEditingController();
//     _videoMetaData = const YoutubeMetaData();
//     _playerState = PlayerState.unknown;
//   }
//
//   void listener() {
//     if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
//       setState(() {
//         _playerState = _controller.value.playerState;
//         _videoMetaData = _controller.metadata;
//       });
//     }
//   }
//
//   @override
//   void deactivate() {
//     // Pauses video while navigating to next page.
//     _controller.pause();
//     super.deactivate();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _idController.dispose();
//     _seekToController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return YoutubePlayerBuilder(
//       onExitFullScreen: () {
//         // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
//         SystemChrome.setPreferredOrientations(DeviceOrientation.values);
//       },
//       player: YoutubePlayer(
//         controller: _controller,
//         showVideoProgressIndicator: true,
//         progressIndicatorColor: Colors.blueAccent,
//         topActions: <Widget>[
//           const SizedBox(width: 8.0),
//           Expanded(
//             child: Text(
//               _controller.metadata.title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 18.0,
//               ),
//               overflow: TextOverflow.ellipsis,
//               maxLines: 1,
//             ),
//           ),
//           IconButton(
//             icon: const Icon(
//               Icons.settings,
//               color: Colors.white,
//               size: 25.0,
//             ),
//             onPressed: () {
//               log('Settings Tapped!');
//             },
//           ),
//         ],
//         onReady: () {
//           _isPlayerReady = true;
//         },
//         onEnded: (data) {
//           _controller
//               .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
//           _showSnackBar('Next Video Started!');
//         },
//       ),
//       // builder: (context, player) => Scaffold(
//       //   appBar: AppBar(
//       //     leading: Padding(
//       //       padding: const EdgeInsets.only(left: 12.0),
//       //       child: Image.asset(
//       //         'assets/ypf.png',
//       //         fit: BoxFit.fitWidth,
//       //       ),
//       //     ),
//       //     title: const Text(
//       //       'Youtube Player Flutter',
//       //       style: TextStyle(color: Colors.white),
//       //     ),
//       //     actions: [
//       //       IconButton(
//       //         icon: const Icon(Icons.video_library),
//       //         onPressed: () => Navigator.push(
//       //           context,
//       //           CupertinoPageRoute(
//       //             builder: (context) => VideoList(),
//       //           ),
//       //         ),
//       //       ),
//       //     ],
//       //   ),
//       //   body: ListView(
//       //     children: [
//       //       player,
//       //       Padding(
//       //         padding: const EdgeInsets.all(8.0),
//       //         child: Column(
//       //           crossAxisAlignment: CrossAxisAlignment.stretch,
//       //           children: [
//       //             _space,
//       //             _text('Title', _videoMetaData.title),
//       //             _space,
//       //             _text('Channel', _videoMetaData.author),
//       //             _space,
//       //             _text('Video Id', _videoMetaData.videoId),
//       //             _space,
//       //             Row(
//       //               children: [
//       //                 _text(
//       //                   'Playback Quality',
//       //                   _controller.value.playbackQuality ?? '',
//       //                 ),
//       //                 const Spacer(),
//       //                 _text(
//       //                   'Playback Rate',
//       //                   '${_controller.value.playbackRate}x  ',
//       //                 ),
//       //               ],
//       //             ),
//       //             _space,
//       //             TextField(
//       //               enabled: _isPlayerReady,
//       //               controller: _idController,
//       //               decoration: InputDecoration(
//       //                 border: InputBorder.none,
//       //                 hintText: 'Enter youtube \<video id\> or \<link\>',
//       //                 fillColor: Colors.blueAccent.withAlpha(20),
//       //                 filled: true,
//       //                 hintStyle: const TextStyle(
//       //                   fontWeight: FontWeight.w300,
//       //                   color: Colors.blueAccent,
//       //                 ),
//       //                 suffixIcon: IconButton(
//       //                   icon: const Icon(Icons.clear),
//       //                   onPressed: () => _idController.clear(),
//       //                 ),
//       //               ),
//       //             ),
//       //             _space,
//       //             Row(
//       //               children: [
//       //                 _loadCueButton('LOAD'),
//       //                 const SizedBox(width: 10.0),
//       //                 _loadCueButton('CUE'),
//       //               ],
//       //             ),
//       //             _space,
//       //             Row(
//       //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       //               children: [
//       //                 IconButton(
//       //                   icon: const Icon(Icons.skip_previous),
//       //                   onPressed: _isPlayerReady
//       //                       ? () => _controller.load(_ids[
//       //                   (_ids.indexOf(_controller.metadata.videoId) -
//       //                       1) %
//       //                       _ids.length])
//       //                       : null,
//       //                 ),
//       //                 IconButton(
//       //                   icon: Icon(
//       //                     _controller.value.isPlaying
//       //                         ? Icons.pause
//       //                         : Icons.play_arrow,
//       //                   ),
//       //                   onPressed: _isPlayerReady
//       //                       ? () {
//       //                     _controller.value.isPlaying
//       //                         ? _controller.pause()
//       //                         : _controller.play();
//       //                     setState(() {});
//       //                   }
//       //                       : null,
//       //                 ),
//       //                 IconButton(
//       //                   icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
//       //                   onPressed: _isPlayerReady
//       //                       ? () {
//       //                     _muted
//       //                         ? _controller.unMute()
//       //                         : _controller.mute();
//       //                     setState(() {
//       //                       _muted = !_muted;
//       //                     });
//       //                   }
//       //                       : null,
//       //                 ),
//       //                 FullScreenButton(
//       //                   controller: _controller,
//       //                   color: Colors.blueAccent,
//       //                 ),
//       //                 IconButton(
//       //                   icon: const Icon(Icons.skip_next),
//       //                   onPressed: _isPlayerReady
//       //                       ? () => _controller.load(_ids[
//       //                   (_ids.indexOf(_controller.metadata.videoId) +
//       //                       1) %
//       //                       _ids.length])
//       //                       : null,
//       //                 ),
//       //               ],
//       //             ),
//       //             _space,
//       //             Row(
//       //               children: <Widget>[
//       //                 const Text(
//       //                   "Volume",
//       //                   style: TextStyle(fontWeight: FontWeight.w300),
//       //                 ),
//       //                 Expanded(
//       //                   child: Slider(
//       //                     inactiveColor: Colors.transparent,
//       //                     value: _volume,
//       //                     min: 0.0,
//       //                     max: 100.0,
//       //                     divisions: 10,
//       //                     label: '${(_volume).round()}',
//       //                     onChanged: _isPlayerReady
//       //                         ? (value) {
//       //                       setState(() {
//       //                         _volume = value;
//       //                       });
//       //                       _controller.setVolume(_volume.round());
//       //                     }
//       //                         : null,
//       //                   ),
//       //                 ),
//       //               ],
//       //             ),
//       //             _space,
//       //             AnimatedContainer(
//       //               duration: const Duration(milliseconds: 800),
//       //               decoration: BoxDecoration(
//       //                 borderRadius: BorderRadius.circular(20.0),
//       //                 color: _getStateColor(_playerState),
//       //               ),
//       //               padding: const EdgeInsets.all(8.0),
//       //               child: Text(
//       //                 _playerState.toString(),
//       //                 style: const TextStyle(
//       //                   fontWeight: FontWeight.w300,
//       //                   color: Colors.white,
//       //                 ),
//       //                 textAlign: TextAlign.center,
//       //               ),
//       //             ),
//       //           ],
//       //         ),
//       //       ),
//       //     ],
//       //   ),
//       // ),
//     );
//   }
//
//   Widget _text(String title, String value) {
//     return RichText(
//       text: TextSpan(
//         text: '$title : ',
//         style: const TextStyle(
//           color: Colors.blueAccent,
//           fontWeight: FontWeight.bold,
//         ),
//         children: [
//           TextSpan(
//             text: value,
//             style: const TextStyle(
//               color: Colors.blueAccent,
//               fontWeight: FontWeight.w300,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _getStateColor(PlayerState state) {
//     switch (state) {
//       case PlayerState.unknown:
//         return Colors.grey[700];
//       case PlayerState.unStarted:
//         return Colors.pink;
//       case PlayerState.ended:
//         return Colors.red;
//       case PlayerState.playing:
//         return Colors.blueAccent;
//       case PlayerState.paused:
//         return Colors.orange;
//       case PlayerState.buffering:
//         return Colors.yellow;
//       case PlayerState.cued:
//         return Colors.blue[900];
//       default:
//         return Colors.blue;
//     }
//   }
//
//   Widget get _space => const SizedBox(height: 10);
//
//   Widget _loadCueButton(String action) {
//     return Expanded(
//       child: MaterialButton(
//         color: Colors.blueAccent,
//         onPressed: _isPlayerReady
//             ? () {
//           if (_idController.text.isNotEmpty) {
//             var id = YoutubePlayer.convertUrlToId(
//               _idController.text,
//             ) ??
//                 '';
//             if (action == 'LOAD') _controller.load(id);
//             if (action == 'CUE') _controller.cue(id);
//             FocusScope.of(context).requestFocus(FocusNode());
//           } else {
//             _showSnackBar('Source can\'t be empty!');
//           }
//         }
//             : null,
//         disabledColor: Colors.grey,
//         disabledTextColor: Colors.black,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 14.0),
//           child: Text(
//             action,
//             style: const TextStyle(
//               fontSize: 18.0,
//               color: Colors.white,
//               fontWeight: FontWeight.w300,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             fontWeight: FontWeight.w300,
//             fontSize: 16.0,
//           ),
//         ),
//         backgroundColor: Colors.blueAccent,
//         behavior: SnackBarBehavior.floating,
//         elevation: 1.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(50.0),
//         ),
//       ),
//     );
//   }
// }