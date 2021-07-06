import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoItems extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  final bool looping;
  final bool autoplay;


  VideoItems({
    @required this.videoPlayerController,
    @required this.chewieController,
    this.looping, this.autoplay,
    Key key,
  }) : super(key: key);

  @override
  _VideoItemsState createState() => _VideoItemsState();
}

class _VideoItemsState extends State<VideoItems> {

  @override
  void initState() {
    super.initState();
    widget.chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      // aspectRatio:4/2,
      autoInitialize: true,
      autoPlay: widget.autoplay,
      looping: widget.looping,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    widget.chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: widget.videoPlayerController.value.aspectRatio,
        child: Chewie(
          controller: widget.chewieController,
        ),
      ),
    );
  }
}


// class VideoItems extends StatelessWidget {
//   final VideoPlayerController videoPlayerController;
//   final bool looping;
//   final bool autoplay;
//
//
//   VideoItems({
//     @required this.videoPlayerController,
//     this.looping, this.autoplay,
//     Key key,
//   }) : super(key: key);
//
//   @override
//   void initState() {
//     super.initState();
//     _chewieController = ChewieController(
//       videoPlayerController: widget.videoPlayerController,
//       aspectRatio:5/8,
//       autoInitialize: true,
//       autoPlay: widget.autoplay,
//       looping: widget.looping,
//       errorBuilder: (context, errorMessage) {
//         return Center(
//           child: Text(
//             errorMessage,
//             style: TextStyle(color: Colors.white),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
