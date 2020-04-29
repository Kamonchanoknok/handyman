import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hdman/config/index.dart';
import 'package:hdman/function/alert.dart';
import 'package:hdman/provider/model/market.dart';
import 'package:hdman/provider/model/user.dart';
import 'package:hdman/widget/TextFieldFix.dart';
import 'package:hdman/widget/TextFix.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  dynamic user = {};

  final password_confirm = TextEditingController();
  final nickname = TextEditingController();
  final nicknameEdit = TextEditingController();

  Future<void> actionLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    prefs.remove('market');
    prefs.remove('market_status');

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final marketProvider = Provider.of<MarketProvider>(context, listen: false);

    userProvider.setUser({});
    marketProvider.setMarket(false);
    marketProvider.setStatus(false);
    marketProvider.setData({});

    Navigator.pop(context);
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Future<void> actionUpdate() async {
    try {
      if (nicknameEdit.text != "" && password_confirm.text != "") {
        UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);

        Dio dio = new Dio();
        Response response = await dio.post("${api}/user/update", data: {
          "id": userProvider.data["id"],
          "nickname": nicknameEdit.text,
          "password": password_confirm.text
        });

        print(response.data["data"]);

        if (response.data["bypass"]) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('user',
              jsonEncode(response.data['data'])); //เก็บข้อมูล user ลง  เครื่อง

          userProvider
              .setUser(response.data['data']); //เก็บข้อมูล user ลง  Provider

          getAlertSuccess(context, "แก้ไขข้อมูลสำเร็จ");
        } else {
          getAlertWarning(context, "แก้ไขข้อมูลไม่สำเร็จกรุณาลองใหม่อีกครั้ง");
        }
      } else {
        getAlertWarning(context, "กรุณากรอกข้อมูลให้ครบ");
      }
    } catch (e) {
      print("error => ${e}");
    }
  }

  Future actionUser() async {
    user = Provider.of<UserProvider>(context, listen: false).data;
    setState(() {
      nickname.text = user['nickname'].toString();
    });
  }

  didChangeDependencies() {
    super.didChangeDependencies();
    actionUser();
  }

  Widget _buildButtonLogout() {
    return FlatButton(
      onPressed: () => actionLogout(),
      child: TextFix(
        title: 'ออกจากระบบ',
        sizefont: 18,
        color: Colors.red,
      ),
    );
  }

  Widget _buildEditProfile() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Center(
          child: Column(
            children: <Widget>[
              Icon(
                Icons.account_circle,
                size: MediaQuery.of(context).size.width / 4,
              ),
              TextFix(
                title: user['username'].toString(),
                sizefont: 18.0,
              ),
              SizedBox(
                height: 10,
              ),
              TextFix(
                title: "ชื่อเล่น : ${nickname.text}",
                sizefont: 16,
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldFix(
                textEdit: nicknameEdit,
                obscure_mode: false,
                title: 'ชื่อเล่น',
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldFix(
                textEdit: password_confirm,
                obscure_mode: false,
                title: 'รหัสผ่าน',
              ),
              SizedBox(
                height: 15,
              ),
              _buildButtonLogout()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => actionUpdate(),
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextFix(
          title: 'แก้ไขโปรไฟล์',
          sizefont: sizeFontHeader,
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: _buildEditProfile(),
      ),
    );
  }
}
