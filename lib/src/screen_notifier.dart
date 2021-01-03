
import 'package:flutter/cupertino.dart';
import 'package:youtube_api/yt_video.dart';

class ScreenNotifier with ChangeNotifier{
  int current_index;
   List<YT_API> ytResult = [];
  ScreenNotifier({this.current_index});

   Set setIndex(index)
  {
    current_index=index;
    notifyListeners();
  }

  Set videoList(data)
  {
    ytResult=data;
    notifyListeners();
  }
}