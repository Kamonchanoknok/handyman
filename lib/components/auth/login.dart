import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hdman/config/index.dart';
import 'package:hdman/function/alert.dart';
import 'package:hdman/provider/model/market.dart';
import 'package:hdman/provider/model/user.dart';
import 'package:hdman/widget/TextFix.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /*
  */

  final username = TextEditingController();
  final password = TextEditingController();

  Future actionLogin() async {
    try {
      if (username.text != "" && password.text != "") {
        Dio dio = new Dio();
        Response response = await dio.post("${api}/auth",
            data: {"username": username.text, "password": password.text});

        print(response.data["data"]);

        if (response.data['bypass']) {
          if (response.data['status'] == "verify") {
            // 0 ยังไม่ยืนยันใน Email
            //กรณีที่ยังไม่ ยืนยันตัวตน
            Navigator.of(context).pushReplacementNamed('/verify',
                arguments: {"email": response.data['data']['email']});
          } else {
            //กรณีที่ ยืนยันตัวตนแล้ว
            SharedPreferences prefs = await SharedPreferences.getInstance();

            await prefs.setBool(
                'market_status',
                response.data["data"]["market"] == 0
                    ? false
                    : true); //เก็บข้อมูล  ลงเครื่อง

            await prefs.setString(
                'user',
                jsonEncode(
                    response.data['data'])); //เก็บข้อมูล user ลง  เครื่อง

            UserProvider userProvider =
                Provider.of<UserProvider>(context, listen: false);

            MarketProvider marketProvider =
                Provider.of<MarketProvider>(context, listen: false);

            userProvider
                .setUser(response.data['data']); //เก็บข้อมูล user ลง  Provider

            marketProvider
                .setStatus(response.data["data"]["market"] == 0 ? false : true);

            Navigator.of(context).pushReplacementNamed('/home');
          }
        } else {
          getAlertWarning(
              context, 'ไม่พบชื่อผู้ใช้ กรุณาลองกรอกข้อมูลใหม่อีกครั้ง !');
        }
      } else {
        getAlertWarning(context, 'กรุณากรอกข้อมูลให้ครบถ้วน');
      }
    } catch (e) {
      print('error => ${e.toString()}');
    }
  }

  void navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  final kHintTextStyle = TextStyle(
    color: Colors.white54,
    fontFamily: getFontFamily,
  );

  final kLabelStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: getFontFamily,
  );

  final kBoxDecorationStyle = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(50.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          Expanded(
              child: Divider(
            color: Colors.red,
            endIndent: 10,
            indent: 5,
          )),
          TextFix(
            title: "หรือ",
            sizefont: 14,
          ),
          Expanded(
              child: Divider(
            color: Colors.red,
            endIndent: 5,
            indent: 10,
          )),
        ]),
        SizedBox(height: 5),
        TextFix(
          title: "เข้าสู่ระบบด้วย",
          sizefont: 20,
        )
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildButton(Function onPressed) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: RaisedButton(
          elevation: 5.0,
          onPressed: onPressed,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          child: TextFix(
            sizefont: 18,
            title: 'เข้าสู่ระบบ',
          ),
        ));
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: username,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(fontFamily: getFontFamily),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
              ),
              hintText: 'กรุณากรอกชื่อผู้ใช้งาน',
              hintStyle: TextStyle(fontFamily: getFontFamily),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: true,
            controller: password,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(fontFamily: getFontFamily),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
              ),
              hintText: 'กรุณากรอกรหัสผ่าน',
              hintStyle: TextStyle(fontFamily: getFontFamily),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInBtn(Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'หากยังไม่ได้เป็นสมัครชิก ',
              style:
                  TextStyle(fontFamily: getFontFamily, color: colorsText_Pri),
            ),
            TextSpan(
              text: 'คลิก',
              style:
                  TextStyle(fontFamily: getFontFamily, color: colorsText_Pri),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => print('Login with Facebook'),
            AssetImage(
              'lib/assets/icons/facebook.png',
            ),
          ),
          _buildSocialBtn(
            () => print('Login with Google'),
            AssetImage(
              'lib/assets/icons/google.png',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: colorsBgAuth,
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 90.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFix(
                          title: 'Handy Man',
                          sizefont: 40,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        _buildEmailTF(),
                        SizedBox(
                          height: 10,
                        ),
                        _buildPasswordTF(),
                        _buildButton(() => actionLogin()),
                        _buildSignInBtn(() {
                          Navigator.of(context)
                              .pushReplacementNamed('/register');
                        }),
                        SizedBox(
                          height: 10,
                        ),
                        _buildSignInWithText(),
                        _buildSocialBtnRow(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
