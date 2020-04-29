import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hdman/config/index.dart';
import 'package:hdman/function/alert.dart';
import 'package:hdman/widget/TextFix.dart';

class VerifyScreen extends StatefulWidget {
  final String email;

  VerifyScreen({Key key, this.email}) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  /*

  */

  Future actionVerify() async {
    try {
      if (verifyCode.text != "") {
        Dio dio = new Dio();
        Response response = await dio.post("${api}/auth/confirm",
            data: {"email": widget.email, "verify_code": verifyCode.text});

        if (response.data['bypass']) {
          Navigator.of(context).pushReplacementNamed('/login');
        } else {
          if (response.data['status'].toString() == "error") {
            getAlertWarning(context, response.data['message'].toString());
          }
        }
      } else {
        getAlertWarning(context, 'กรุณากรอกข้อมูลให้ครบถ้วน');
      }
    } catch (e) {
      getAlertError(context, e.toString());
    }
  }

  final verifyCode = TextEditingController();

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
        padding: EdgeInsets.symmetric(vertical: 15.0),
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
            title: 'ยืนยันตัวตน',
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
                          title: 'การยืนยันตัวตนเพื่อใช้งาน',
                          sizefont: 30,
                        ),
                        TextFix(
                          title: 'HadyMan',
                          sizefont: 35,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFix(
                          title: 'ตรวจสอบ email ที่ท่านใช้ลงทะเบียนเพื่อดูรหัส',
                        ),
                        TextFix(
                          title: 'email ที่ใช้สมัครคือ : ${widget.email}',
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _buildInput('กรุณากรอกรหัสยืนยันตัวตน',
                            Icons.verified_user, false, verifyCode),
                        SizedBox(
                          height: 10,
                        ),
                        _buildButton(() => actionVerify()),
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
