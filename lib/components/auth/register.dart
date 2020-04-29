import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hdman/config/index.dart';
import 'package:hdman/function/alert.dart';
import 'package:hdman/widget/TextFix.dart';
//import 'package:hd_man/screens/auth/otp.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /*

  */
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  Future<void> actionRegister() async {
    try {
      if (username.text != "" && email.text != "" && password.text != "") {
        Dio dio = new Dio();
        Response response = await dio.post("${api}/user/create", data: {
          "username": username.text,
          "password": password.text,
          "email": email.text
        });

        if (response.data["bypass"]) {
//          getAlertSuccess(
//            context,
//            'สมัครสมาชิกเรียบร้อย ระบบได้ทำการส่งรหัสยืนยันตัวตนไปให้คุณทาง email แล้ว !',
//          );

          Navigator.of(context).pushReplacementNamed('/verify',
              arguments: {'email': email.text});
        } else {
          if (response.data["status"] == "failed") {
            getAlertWarning(context, response.data["message"]);
          } else {
            getAlertWarning(
                context, "ไม่สามารถสมัครสมาชิกได้กรุณาลองให่มอีกครั้ง !");
          }
        }
      } else {
        getAlertWarning(context, "กรุณากรอกข้อมูลให้ครบ !");
      }
    } catch (e) {
      print(e);
    }
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
            title: 'สมัครสมาชิก',
          ),
        ));
  }

  Widget _buildInput(title, icons, passtype, controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: controller,
            obscureText: passtype ? true : false,
            style: TextStyle(fontFamily: getFontFamily),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                icons,
              ),
              hintText: title,
              hintStyle: TextStyle(fontFamily: getFontFamily),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackBtn(Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'กลับไปยังหน้า `เข้าสู่ระบบ`',
              style: TextStyle(
                  fontFamily: getFontFamily,
                  color: colorsText_Pri,
                  fontSize: 16),
            ),
          ],
        ),
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
                          title: 'สมัครใช้งานแอพพลิเคชั่น',
                          sizefont: 30,
                        ),
                        TextFix(
                          title: 'HadyMan',
                          sizefont: 35,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        _buildInput('กรุณากรอกชื่อผู้ใช้งาน', Icons.people,
                            false, username),
                        SizedBox(
                          height: 10,
                        ),
                        _buildInput(
                            'กรุณากรอกอีเมลล์', Icons.email, false, email),
                        SizedBox(
                          height: 10,
                        ),
                        _buildInput(
                            'กรุณากรอกรหัสผ่าน', Icons.lock, true, password),
                        _buildButton(() => actionRegister()),
                        _buildBackBtn(() {
                          Navigator.of(context).pushReplacementNamed('/login');
                        }),
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
