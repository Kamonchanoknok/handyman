import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hdman/config/index.dart';
import 'package:hdman/function/alert.dart';
import 'package:hdman/provider/model/market.dart';
import 'package:hdman/provider/model/user.dart';
import 'package:hdman/widget/TextFieldFix.dart';
import 'package:hdman/widget/TextFix.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class StoresScreen extends StatefulWidget {
  StoresScreen({Key key}) : super(key: key);

  @override
  _StoresScreenState createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  /*
  
  */

  final nameStore = TextEditingController();
  String categoryStore;
  final addressStore = TextEditingController();

  dynamic user = {};

  Future actionStoreMe() async {
    print('actionStoreMe !');
    try {
      final data = Provider.of<UserProvider>(context, listen: false).data;
      final marketData = Provider.of<MarketProvider>(context, listen: false);

      Dio dio = new Dio();
      Response response = await dio.get("${api}/market/${data["id"]}");

      if (response.data["data"] != null) {
        setState(() {
          marketData.setData(response.data["data"]);
          nameStore.text = response.data["data"]["name"];
          addressStore.text = response.data["data"]["address"];
          categoryStore = response.data["data"]["category"];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  didChangeDependencies() {
    super.didChangeDependencies();
    actionStoreMe();
  }

  List<DropdownMenuItem> items = [
    DropdownMenuItem(
      child: TextFix(
        title: 'ช่างคอมพิวเตอร์',
      ),
      value: 'ช่างคอมพิวเตอร์',
    ),
  ];

  Widget _buildDropdownFix() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: SearchableDropdown.single(
        style: TextStyle(fontFamily: getFontFamily, fontSize: 18),
        items: items,
        clearIcon: Icon(
          Icons.close,
          color: Colors.white,
        ),
        value: categoryStore,
        hint: "เลือกประเภทการให้บริการ",
        searchHint: "เลือกประเภทการให้บริการ",
        onChanged: (value) {
          setState(() {
            categoryStore = value.toString();
          });
        },
        onClear: () {
          setState(() {
            categoryStore = null;
          });
        },
        isExpanded: true,
      ),
    );
  }

  void actionAddList() {
    if (nameStore.text != "") {
      Navigator.of(context).pushNamed("/product");
    } else {
      getAlertWarning(
          context, "กรุณาตั้งชื่อร้านของคุณให้เรียบร้อยก่อน ใช้งานปุ่มนี้ !");
    }
  }

  Future<void> actionUpdate() async {
    user = Provider.of<UserProvider>(context, listen: false).data;
    //user['id']
    try {
      if (nameStore.text != "" &&
          addressStore.text != "" &&
          categoryStore != null) {
        Dio dio = new Dio();
        Response response = await dio.post("${api}/market/create", data: {
          "id_account": user['id'],
          "name": nameStore.text,
          "category": categoryStore,
          "status": 1,
          "address": addressStore.text
        });

        print(response.data);

        if (response.data['bypass']) {
          getAlertSuccess(context, "แก้ไขร้านของคุณเเรียบร้อย");
        } else {
          getAlertWarning(
              context, "ไม่สามารถแก้ไขร้านของคุณเได้กรุณาลองใหม่อีกครั้ง");
        }
      } else {
        getAlertWarning(context, "กรุณากรอกข้อมูลให้ครบ !");
      }
    } catch (e) {
      print('error => ${e.toString()}');
    }
  }

  Widget _buildButtongs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          onPressed: () => actionUpdate(),
          child: TextFix(
            title: 'อัปเดตร้านค้า',
            sizefont: 18,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        FlatButton(
          onPressed: () => actionAddList(),
          child: TextFix(
            title: 'เพิ่มรายการ',
            sizefont: 18,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 100.0,
        ),
        physics: AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFix(
                title: 'ร้านค้าของคุณ',
                sizefont: 24,
              ),
              SizedBox(
                height: 20,
              ),
              TextFieldFix(
                textEdit: nameStore,
                obscure_mode: false,
                title: 'ชื่อร้านค้าของคุณ',
              ),
              SizedBox(
                height: 20,
              ),
              TextFieldFix(
                textEdit: addressStore,
                obscure_mode: false,
                title: 'ที่อยู่ร้านค้า',
              ),
              SizedBox(
                height: 20,
              ),
              _buildDropdownFix(),
              SizedBox(
                height: 20,
              ),
              _buildButtongs()
            ],
          ),
        ),
      ),
    );
  }
}
