
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:video_player/video_player.dart';

class SwiperClass extends StatefulWidget {
  @override
  _SwiperClassState createState() => _SwiperClassState();
}

class _SwiperClassState extends State<SwiperClass> {
  List media = new List();
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;
  TargetPlatform _platform;



  @override
  void initState() {
    super.initState();
    _videoPlayerController1 = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1,
        aspectRatio: 3 / 2,
        autoPlay: true,
        looping: true,);
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Slider"),
      ),
      body: new Stack(
        children: <Widget>[
          ConstrainedBox(
            constraints: new BoxConstraints.expand(),
          ),
          new Swiper.children(
            autoplay: true,
            pagination: new SwiperPagination(
                margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
                builder: new DotSwiperPaginationBuilder(
                    color: Colors.white30,
                    activeColor: Colors.green,
                    size: 20.0,
                    activeSize: 20.0)),
            children: <Widget>[
              new Image.network(
                "https://images.pexels.com/photos/457882/pexels-photo-457882.jpeg?cs=srgb&dl=beach-calm-clouds-idyllic-457882.jpg&fm=jpg",
                fit: BoxFit.contain,
              ),
              new Image.network(
                "https://images.pexels.com/photos/457882/pexels-photo-457882.jpeg?cs=srgb&dl=beach-calm-clouds-idyllic-457882.jpg&fm=jpg",
                fit: BoxFit.contain,
              ),
              new Image.network("https://images.pexels.com/photos/457882/pexels-photo-457882.jpeg?cs=srgb&dl=beach-calm-clouds-idyllic-457882.jpg&fm=jpg", fit: BoxFit.contain),

            new Column(
              children: <Widget>[
                Expanded(
                  child:   new Chewie(
                    controller: _chewieController,
                  ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _chewieController.enterFullScreen();
                    },
                  ),
              ],
            ),
              ],
            )
            ],

      ),
    );
  }
}
