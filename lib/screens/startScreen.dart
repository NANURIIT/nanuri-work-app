import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'loginPage.dart';
import 'noticePage.dart';

//앱 실행시 실행되는 임시 페이지
var session = FlutterSession();

class StartScreen extends StatefulWidget{


  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>{

  bool isLogin = false;
  String text = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("called init");
    _loadSession();
  }


  _loadSession() async {

    isLogin = await session.get("isLogin"); // 현재 로그인 상태인지 확인해서 콘솔에 출력
    print("_loadSession called = " + isLogin.toString());
    if(isLogin == true){ //로그인 상태라면 공지사항 페이지, 로그인 상태가 아니면 로그인 페이지로 이동
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>NoticePage()));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>NoticePage()));
    }
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }


}