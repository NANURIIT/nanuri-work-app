import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

import 'attendPage.dart';
import 'noticePage.dart';

//쿠키에서 세션id, 로그인 id, 권한정보 받아야함

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  WebViewController? _webViewController;

  String id = ""; //쿠키에서 id 불러오기
  String authlevel = "";//쿠키에서 권한 불러오기

  @override
  void initState() {
    super.initState();

    //여기서 세션 불러와야하나?

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;
    Color backgroundColor;
    return MaterialApp(
      home: WillPopScope(
        onWillPop: () => _goBack(context),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Profile Page"),
            // 현재 페이지가 뭔지 일단 적어둠. 나중에 회사 아이콘으로 바꿀지?
            centerTitle: true,
            elevation: 0,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app), // 로그아웃 아이콘 생성
                onPressed: () {
                  // 아이콘 버튼 실행
                  print('Exit button is clicked');
                },
              ),
            ],
          ), drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(//권한이 있는 경우 여기서 여러 링크를 확인할 수 있도록 한다.
                title: const Text('공지사항 등록'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('신규직원 등록'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('장비 등록'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
          body: Column(
            children: [

              Expanded(
                child: WebView(
                  initialUrl: 'https://google.com', //회원정보 페이지로 URI 바꿔야함
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              ),
              BottomNavigationBar(
                  onTap: (int index) {
                    switch (index) {
                      case 0:
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>NoticePage()));
                        break;
                      case 1:
                        break;
                      case 2:
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AttendPage()));
                        break;
                      default:
                    }
                  },
                  items: [
                    BottomNavigationBarItem(icon: Icon(
                        Icons.circle_notifications),
                        label: "공지"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.account_circle),
                        label: "개인정보"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.event_note_rounded),
                        label: "근태정보"),
                  ],selectedItemColor: Colors.blueAccent,selectedLabelStyle: TextStyle(color: Colors.blueAccent),)
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _goBack(BuildContext context) async {
    if (_webViewController == null) {
      return true;
    }
    if (await _webViewController!.canGoBack()) {
      _webViewController!.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  void dbconnect() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'nanuriit.com',
        port: 7706,
        user: 'work',
        db: 'work',
        password: 'Nanuriwork1!'));
  }
}
