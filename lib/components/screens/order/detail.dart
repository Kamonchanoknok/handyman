import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hdman/components/screens/home/index.dart';
import 'package:hdman/config/index.dart';
import 'package:hdman/function/alert.dart';
import 'package:hdman/widget/TextFix.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:core';
import 'dart:async';

class DetailOrderScreen extends StatefulWidget {
  final int idUser;
  final int idHistory;
  final data;

  DetailOrderScreen({Key key, this.idHistory, this.idUser, this.data})
      : super(key: key);

  @override
  _DetailOrderScreenState createState() => _DetailOrderScreenState();
}

class _DetailOrderScreenState extends State<DetailOrderScreen> {
  dynamic userData = [];
  bool loadingChecked = true;
  Future<void> _launched;

  didChangeDependencies() {
    super.didChangeDependencies();
    actionGetUser();
  }

  Future actionUpdateOrder() async {
    try {
      Dio dio = new Dio();
      Response response = await dio.post("${api}/history/update", data: {
        "id": widget.idHistory,
        "status": widget.data['status_next_number'].toString()
      });

      if (response.data["bypass"]) {
        getAlertSuccess(context, "ทำรายการสำเร็จ !");
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => true,
          );
        });
      } else {
        getAlertWarning(context, "ทำรายกายไม่สำเร็จ กรุณาติดต่อผู้ดูแลระบบ !");
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => true,
          );
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future actionCancel() async {
    try {
      Dio dio = new Dio();
      Response response = await dio.post("${api}/history/update",
          data: {"id": widget.idHistory, "status": 5});

      if (response.data["bypass"]) {
        getAlertSuccess(context, "ยกเลิกรายการสำเร็จ !");
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => true,
          );
        });
      } else {
        getAlertWarning(context, "ทำรายกายไม่สำเร็จ กรุณาติดต่อผู้ดูแลระบบ !");
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => true,
          );
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> actionGetUser() async {
    try {
      Dio dio = new Dio();
      Response response =
          await dio.get("${api}/user/${widget.idUser.toString()}");

      setState(() {
        userData = response.data["data"];
        loadingChecked = false;
      });
    } catch (e) {
      //เกิด error ระหว่างโหลด

    }
  }

  Widget _buildButtonClose() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      color: Colors.redAccent,
      child: FlatButton(
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(8.0),
          splashColor: Colors.blueAccent,
          onPressed: () => actionCancel(),
          child: TextFix(
            title: "ยกเลิกรายการ",
            sizefont: 18,
          )),
    );
  }

  Widget _buildButtonOk() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      color: Colors.green,
      child: FlatButton(
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(8.0),
          splashColor: Colors.blueAccent,
          onPressed: () => actionUpdateOrder(),
          child: TextFix(
            title: "ดำเนินการขั้นตอนไป",
            sizefont: 18,
          )),
    );
  }

  Widget _buildTextField(title, val, icon, func) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          onTap: func,
          controller: TextEditingController(text: val.toString()),
          style: TextStyle(fontFamily: getFontFamily),
          readOnly: true,
          decoration: InputDecoration(
              labelStyle: TextStyle(fontFamily: getFontFamily),
              labelText: title,
              prefixIcon: Icon(icon),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ))),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildScrenns() {
    if (loadingChecked) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[CircularProgressIndicator()],
      ));
    } else {
      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFix(
                  title: "ข้อมูลของลูกค้า",
                  sizefont: 18,
                ),
                SizedBox(
                  height: 10,
                ),
                _buildTextField("ชื่อลูกค้า", userData["username"].toString(),
                    Icons.people, () => {}),
                _buildTextField(
                    "เบอร์ติดต่อ", widget.data['tel'].toString(), Icons.phone,
                    () {
                  final number = widget.data['tel'].toString();
                  _launched = _makePhoneCall('tel:$number');
                }),
                _buildTextField("ที่อยู่ลูกค้า", widget.data['adr'].toString(),
                    Icons.gps_fixed, () => {}),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                TextFix(
                  title: "รายการที่ลูกค้าเลือก",
                  sizefont: 18,
                ),
                _buildTextField("รายการ", widget.data['product_name'],
                    Icons.settings, () => {}),
                _buildTextField(
                    "ราคา",
                    "${widget.data['product_price'].toString()} ${widget.data['product_service'].toString()}",
                    Icons.monetization_on,
                    () => {}),
                SizedBox(
                  height: 10,
                ),
                TextFix(
                  title:
                      "สถานะปัจจุบันคือ : ${widget.data['status_name'].toString()}",
                  sizefont: 18,
                ),
                TextFix(
                  title:
                      "สถานะต่อไปคือ : ${widget.data['status_next'].toString()}",
                  sizefont: 18,
                ),
                SizedBox(
                  height: 15,
                ),
                _buildButtonOk(),
                SizedBox(
                  height: 10,
                ),
                _buildButtonClose(),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextFix(
            title:
                'รายละเอียดออเดอร์ ${widget.data['product_name'].toString()}',
            sizefont: sizeFontHeader,
          ),
        ),
        body: _buildScrenns());
  }
}
