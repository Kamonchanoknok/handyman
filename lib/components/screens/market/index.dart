import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hdman/config/index.dart';
import 'package:hdman/function/alert.dart';
import 'package:hdman/provider/model/market.dart';
import 'package:hdman/provider/model/user.dart';
import 'package:hdman/widget/TextFix.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarketScreen extends StatefulWidget {
  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  bool isOpen = false;

  Future<void> actionOpenMt(status) async {
    print(status);
    final marketProvider = Provider.of<MarketProvider>(context, listen: false);

    final user = Provider.of<UserProvider>(context, listen: false).data;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Dio dio = new Dio();
    Response response = await dio.post("${api}/market/openmt",
        data: {"status": status ? 1 : 0, "id_account": user["id"]});

    print(response.data);

    if (response.data['status'].toString() == "NullMarket") {
      getAlertWarning(context,
          'คุณยังไม่ได้ตั้งค่าร้านค่าของคุณ กรุณาเข้าไปตั้งค่าร้านด้วยการ `เข้าโหมดหน้าร้านของคุณ` ');

      await prefs.setBool('market_status', false); //เก็บข้อมูล  ลงเครื่อง

      setState(() {
        isOpen = false;
      });
    } else {
      await prefs.setBool('market_status', status); //เก็บข้อมูล  ลงเครื่อง

      marketProvider.setStatus(status);
    }
  }

  Widget _buildTitleList() {
    return Container(
      height: MediaQuery.of(context).size.height / 6,
      color: Colors.black38,
      child: Column(
        children: <Widget>[
          ListTile(
            title: TextFix(
              title: 'เข้าโหมดหน้าร้านของคุณ',
              sizefont: 16,
            ),
            trailing: Switch(
              value: Provider.of<MarketProvider>(context, listen: false).color,
              onChanged: (value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool(
                    'market', value); //เก็บข้อมูล user ลง  เครื่อง

                MarketProvider marketProvider =
                    Provider.of<MarketProvider>(context, listen: false);

                marketProvider.setMarket(value);
                Navigator.pop(context);
              },
            ),
          ),
          ListTile(
            title: TextFix(
              title: 'เปิดร้านค้าของคุณ',
              sizefont: 16,
            ),
            trailing: Switch(
              value: Provider.of<MarketProvider>(context, listen: false).status,
              onChanged: (value) => actionOpenMt(value),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          title: TextFix(
            sizefont: sizeFontHeader,
            title: 'ร้านค้าของคุณ',
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15),
              child: TextFix(
                title: "ตั้งการเปิดร้าน",
                sizefont: 18,
              ),
            ),
            _buildTitleList(),
          ],
        ));
  }
}
