import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:yutube_video/src/screen_notifier.dart';
class DemoApp extends StatefulWidget {
  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {

  static String key = "";

  YoutubeAPI ytApi = YoutubeAPI(key);


  Future callAPI()  {
    String query = "Flutter TPoint";
    return ytApi.channel("UChcz-3skEk2Akpn3X2q1nQg",order: "date");


  }

  @override
  void initState() {
    super.initState();
    callAPI();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube API'),
      ),
      body:  Consumer<ScreenNotifier>(builder: (context,screenprovider,child){

        return  (screenprovider.ytResult==null||screenprovider.ytResult.isEmpty)?FutureBuilder(
          future: callAPI(),
          builder: (context, snapshot) {
            screenprovider.videoList(snapshot.data);
            if(screenprovider.ytResult!=null)
            {
              return Container(

                child: ListView.builder(
                  itemCount: screenprovider.ytResult.length,
                  itemBuilder: (_, int index) => listItem(screenprovider.ytResult[index]),
                ),
              );
            }else{
              return Container(height:double.infinity,child: Center(child: CircularProgressIndicator(backgroundColor: Colors.green,)));
            }

          }  ,
        ):Container(
          child: ListView.builder(
            itemCount: screenprovider.ytResult.length,
            itemBuilder: (_, int index) => listItem(screenprovider.ytResult[index]),
          ),
        );
      })

    );
  }

  Widget listItem(video) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) {
              return VideoPlayerScreen(
                video: video,
              );
            }));
      },
      child: Card(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 7.0),
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              Image.network(
                video.thumbnail['default']['url'],
              ),
              Padding(padding: EdgeInsets.only(right: 20.0)),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          video.title,
                          softWrap: true,
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 1.5)),
                        Text(
                          video.channelTitle,
                          softWrap: true,
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 3.0)),
                        Text(
                          video.url,
                          softWrap: true,
                        ),
                      ]))
            ],
          ),
        ),
      ),
    );
  }
}


class VideoPlayerScreen extends StatefulWidget {
  //
  VideoPlayerScreen({this.video});
  final YT_API video ;
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}
class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  //
  YoutubePlayerController _controller;
  bool _isPlayerReady;
  @override
  void initState() {
    super.initState();
    _isPlayerReady = false;
    _controller = YoutubePlayerController(

      initialVideoId: widget.video.id,

      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    )..addListener(_listener);
  }
  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      //
    }
  }
  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    String desc=widget.video.description;
    String link="";
    if(desc.contains("http")) {
      link = desc.substring(desc.indexOf("http"));
      link=link.split(" ")[0];

      if(link.endsWith(".")) {
        desc= desc.replaceAll(link, "");
        link = link.substring(0,link.lastIndexOf("."));

      }

    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.id),
      ),
      body: Container(
        child: ListView(
          children: [
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              onReady: () {

                _isPlayerReady = true;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            style: TextStyle(color: Colors.black,fontSize: 20),
                            text: desc
                        ),
                        TextSpan(
                            style: TextStyle(color: Colors.red,fontSize: 20),
                            text: link,
                            recognizer: TapGestureRecognizer()..onTap =  () async{
                              var url = link;


                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            }
                        ),
                      ]
                  )),
            )


          ],
        ),
      ),
    );
  }
}