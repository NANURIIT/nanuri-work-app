import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import '../helper/login_background.dart';
import 'noticePage.dart';
import 'package:dio/dio.dart';
import 'startScreen.dart';


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _useridController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String inputId = "";
  String inputPw = "";

  get http => null;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: size,
          painter: LoginBackground(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _logoImage,
            Stack(
              children: [_inputForm(size), _authButton(size)],
            ),
          ],
        )
      ],
    ));
  }

  Widget get _logoImage => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 50,
            left: 24,
            right: 24,
          ),
          child: FittedBox(
            fit: BoxFit.contain,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.asset(
                  "images/nanuriit_logo.png",
                ),
              ),
            ),
          ),
        ),
      );

  Widget _inputForm(Size size) => Padding(
        padding: EdgeInsets.fromLTRB(
          size.width * 0.05,
          size.height * 0.05,
          size.width * 0.05,
          size.height * 0.22,
        ),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 6,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 16, left: 12, right: 12, bottom: 35),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _useridController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.account_circle),
                        labelText: "ID",
                      ),
                      onChanged: (inputid) {
                        inputId = inputid;
                        print('ID = $inputid');
                      },
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Please input correct ID.";
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.vpn_key),
                          labelText: "Password",
                        ),
                        onChanged: (inputpw) {
                          inputPw = inputpw;
                          print('password = $inputpw');
                        },
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "Please input correct Password.";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      height: 15,
                    ),
                  ],
                )),
          ),
        ),
      );

  Widget _authButton(Size size) => Positioned(
        left: size.width * 0.15,
        right: size.width * 0.15,
        bottom: size.height * 0.15,
        child: SizedBox(
          height: 50,
          child: RaisedButton(
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _login(context, inputId, inputPw);
                }
              }),
        ),
      );

  Future _login(BuildContext context, String inputId, String inputPw) async {
    //로그인 버튼 누르면 서버에 리퀘스트 보내야함
    print("Input ID : " + _useridController.text);
    print("Inpit PW : " + _passwordController.text);

    Dio dio = new Dio();

    dio.options.headers["Content-type"] = "application/json";
    dio.options.headers["Accept-Charset"] = "utf-8";
    dio.options.headers["Accept"] = "application/json";



    var url = "http://dev.huray.kr:8013/test/token"; //로그인 url,
    print("post url : $url");


    var response = await dio.post(

      url,
      data: {
        //입력된 id와 pw로 리퀘스트 보냄
        "Id": _useridController.text,
        "password": _passwordController.text,
      },
    );

    print("post end");


    print(response.data);

    var data = json.decode(response.data);
    print(response.data);

    if (data == "Success") {
      //로그인 성공하면 세션에 id 넣고 로그인 상태로 만들어 공지사항 페이지로 이동

      await session.set('token', _useridController.text);
      await session.set("isLogin", true);

      Navigator.pop;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NoticePage()),
      );
    }
  }
}
