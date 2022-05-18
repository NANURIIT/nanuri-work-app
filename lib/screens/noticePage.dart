import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';


//쿠키에서 id, 권한 받아오기

class NoticePage extends StatefulWidget {
  @override
  NoticePageState createState() => NoticePageState();
}

class NoticePageState extends State<NoticePage> {
  WebViewController? _webViewController;

  String webViewUrl = "https://google.com";
  String authLevel = "ADMIN"; //API로 받은 권한값으로 바꿔줘야함
  String token = "token"; //받은 토큰
  get naviIndex => null;

  bool isEnableTile = false; // 받은 권한 정보에 따라 바꿔줘야함


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    Color backgroundColor;
    return MaterialApp(
      home: WillPopScope(
        onWillPop: () => _goBack(context),
        child: Scaffold(
          appBar: AppBar(
            title: Text("나누리아이티"),
            // 현재 페이지가 뭔지 일단 적어둠. 나중에 회사 아이콘으로 바꿀지?
            centerTitle: true,
            elevation: 0,

            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app), // 로그아웃 아이콘 생성
                onPressed: () {
                  LogOut();
                  // 아이콘 버튼 실행
                  print('Exit button is clicked');
                },
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('안녕하세요, ㅇㅇㅇ 님'), //여기에 사용자 이름 넣기?
                ),
                ListTile(
                    //권한이 있는 경우 여기서 여러 링크를 확인할 수 있도록 한다.
                    title: const Text('공지사항 등록'),
                    textColor:
                        (isEnableTile == true) ? Colors.black : Colors.grey,
                    onTap: () {
                      if (isEnableTile == true) {
                        webViewUrl = "http://공지등록";
                        _webViewController?.loadUrl(webViewUrl);
                        //공지사항 등록 페이지 링크로 이동
                      } else {
                        //권한이 없어서 접근 불가능하다는 팝업 띄우기
                        null;
                      }
                    }),
                ListTile(
                    title: const Text('신규직원 등록'),
                    textColor:
                        (isEnableTile == true) ? Colors.black : Colors.grey,
                    onTap: () {
                      if (isEnableTile == true) {
                        webViewUrl = "http://신규직원";
                        _webViewController?.loadUrl(webViewUrl);
                        //신규직원 등록 페이지 링크로 이동
                      } else {
                        //권한이 없어서 접근 불가능하다는 팝업 띄우기
                        null;
                      }
                    }),
                ListTile(
                    title: const Text('장비 등록'),
                    textColor:
                        (isEnableTile == true) ? Colors.black : Colors.grey,
                    onTap: () {
                      if (isEnableTile == true) {
                        webViewUrl = "http://장비등록";
                        _webViewController?.loadUrl(webViewUrl);
                        //장비 등록 페이지 링크로 이동
                      } else {
                        //권한이 없어서 접근 불가능하다는 팝업 띄우기
                        null;
                      }
                    }),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: WebView(
                  initialUrl: webViewUrl,
                  /*'https://172.30.1.40:8080/mobile/notice', */
                  //공지사항 URI로 바꿔야 함
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    Map<String, String> headers = {"Authorization": token}; //토큰값을 여기에 넣음
                    _webViewController = webViewController;
                    _webViewController?.loadUrl(webViewUrl, headers: headers);
                  },
                ),
              ),
              BottomNavigationBar(
                onTap: (int index) {
                  switch (index) {
                    case 0:
                      webViewUrl = "https://www.google.com"; // 공지사항 Url로 바꿔야 함
                      _webViewController?.loadUrl(webViewUrl);
                      break;
                    case 1:
                      webViewUrl = "https://www.naver.com"; // 개인정보 Url로 바꿔야 함
                      _webViewController?.loadUrl(webViewUrl);
                      break;
                    case 2:
                      webViewUrl = "https://www.daum.net"; // 근태정보 Url로 바꿔야 함
                      _webViewController?.loadUrl(webViewUrl);
                      break;
                    default:
                  }
                },
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.circle_notifications), label: "공지사항"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle), label: "개인정보"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.event_note_rounded), label: "근태정보"),
                ],
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.red,
                selectedLabelStyle: TextStyle(color: Colors.blueAccent),
              )
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

  void LogOut() async {}
}

