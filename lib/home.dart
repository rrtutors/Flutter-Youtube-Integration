import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';
import 'package:yutube_video/src/screen_notifier.dart';
import 'package:yutube_video/src/search_screen.dart';

import 'mychannel.dart';

/*class HomeTab extends StatefulWidget{
  @override
  _HomeTabState createState() => _HomeTabState();
}*/

class HomeTab extends StatelessWidget{

  int current_index=0;
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.redAccent
      ),
      home:  Consumer<ScreenNotifier>(builder: (context,screenprovider,child)=>Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.redAccent,
          onTap: (index){

            screenprovider.setIndex(index);
          },
            currentIndex: screenprovider.current_index,
            unselectedItemColor: Colors.white70,
            selectedItemColor: Colors.white,
            items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "My Channel"),
          BottomNavigationBarItem(icon: Icon(Icons.search),label: "Search")
        ]),
        body:    Builder(
         builder: (BuildContext context) {
                    return OfflineBuilder(connectivityBuilder:
                        (BuildContext context, ConnectivityResult connectivity,
                            Widget child) {
                      final bool connected =
                          connectivity != ConnectivityResult.none;

                      if(connected) screenprovider.setIndex(1);

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          child,
                          Positioned(
                            left: 0.0,
                            right: 0.0,
                            top: 20,
                            height: 32.0,
                            child: (connected)?Container():AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              color:
                              connected ? Colors.green : Colors.brown,
                              child: connected
                                  ?  Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Online",
                                    style: TextStyle(color: Colors.white),
                                  ),

                                ],
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Offline",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  SizedBox(
                                    width: 12.0,
                                    height: 12.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor:
                                      AlwaysStoppedAnimation(
                                          Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );;
                    },child: (screenprovider.current_index==0)?DemoApp():VideoSearch(),);
                  },

    )
    )));
  }
}