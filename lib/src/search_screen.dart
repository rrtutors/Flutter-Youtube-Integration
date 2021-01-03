import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_api/youtube_api.dart';

import '../mychannel.dart';

class VideoSearch extends StatefulWidget{
  @override
  _VideoSearchState createState() => _VideoSearchState();
}

class _VideoSearchState extends State<VideoSearch> {
  List<YT_API> ytResult = [];

  TextEditingController searchController=TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: TextField(decoration: InputDecoration(hintText: "Search Videos"),controller: searchController,),
          actions: [
            IconButton(  icon: Icon(Icons.search), onPressed: (){


             ytApi.search(searchController.text).then((ss) => {
             setState(() {
             print("Result ${ss.length}  $ss");
             ytResult=ss;
             })
             }) ;

            })
          ]
      ),
      body: FutureBuilder(
        future: callAPI(),
        builder: (context, snapshot) {
          ytResult=(snapshot.data);
          if(ytResult!=null)
          {
            return Container(

              child: ListView.builder(
                itemCount: ytResult.length,
                itemBuilder: (_, int index) => listItem(ytResult[index],context),
              ),
            );
          }else{
            return Container(height:double.infinity,child: Center(child: CircularProgressIndicator(backgroundColor: Colors.green,)));
          }

        }  ,
      ),
    );
  }

  Widget listItem(video,context) {
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

  Future callAPI()  {
    String query = searchController.text;
    return ytApi.search(query);

  }
}
 String key = "";

YoutubeAPI ytApi = YoutubeAPI(key);



