import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hdman/components/screens/home/index.dart';
import 'package:hdman/config/index.dart';
import 'package:hdman/function/alert.dart';
import 'package:hdman/provider/model/user.dart';
import 'package:hdman/widget/TextFix.dart';
import 'package:provider/provider.dart';

class ExploreConfirmScreen extends StatefulWidget {
  final data;

  ExploreConfirmScreen({Key key, this.data}) : super(key: key);

  @override
  _ExploreConfirmScreenState createState() => _ExploreConfirmScreenState();
}

class _ExploreConfirmScreenState extends State<ExploreConfirmScreen> {
  TextEditingController gpsField = TextEditingController();
  TextEditingController phoneField = TextEditingController();

  Widget _buildTextField(title, val, icon, func, type) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: TextField(
          onTap: func,
          controller: val,
          style: TextStyle(fontFamily: getFontFamily),
          keyboardType: type,
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

  Future<void> actionBuyProduct() async {
    /*paramater ที่ต้องส่ง
      - idUser
      - idMarket
      - idProduct
      - status = 0 / เริ่มทางร้านค้ารับเรื่อง
    */

    if (phoneField.text != "" && gpsField.text != "") {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      Dio dio = new Dio();

      Response response = await dio.post("${api}/product/buy", data: {
        "account_id": userProvider.data["id"],
        "market_id": widget.data["id_market"],
        "product_id": widget.data["id"],
        "tel": phoneField.text,
        "adr": gpsField.text,
        "comment": "-"
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
        getAlertWarning(
            context, "ไม่สามารถเลือกรายการนี้ได้ กรุณาลองใหม่อีกครั้ง !");
      }
    } else {
      getAlertWarning(context, "กรุณากรอกข้อมูลให้ครบถ้วน !");
    }
  }

  Widget _buildButtonOk() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.green,
      child: FlatButton(
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(8.0),
          splashColor: Colors.blueAccent,
          onPressed: () => actionBuyProduct(),
          child: TextFix(
            color: Colors.white,
            title: "ตกลง",
            sizefont: 18,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFix(
          title: 'กรอกข้อมูลเพิ่มเติม - ${widget.data['name']}',
          sizefont: sizeFontHeader,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFix(
              title: "รายการที่คุณเลือกคือ : ${widget.data['name']}",
              sizefont: 18,
            ),
            TextFix(
                title:
                    "ราคา : ${widget.data['price']} ${widget.data['service']}",
                sizefont: 18),
            _buildTextField("เบอร์โทรของคุณ", phoneField, Icons.phone, () => {},
                TextInputType.number),
            _buildTextField("ที่อยู่ของคุณ", gpsField, Icons.gps_fixed,
                () => {}, TextInputType.text),
            SizedBox(
              height: 20,
            ),
            _buildButtonOk()
          ],
        ),
      ),
    );
  }
}
