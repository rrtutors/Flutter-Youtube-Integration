import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:yutube_video/src/screen_notifier.dart';

import 'home.dart';

void main() {
  runApp(
      ChangeNotifierProvider<ScreenNotifier>(create: (contex)=>ScreenNotifier(current_index:0),child: HomeTab() ,)

  );
}

