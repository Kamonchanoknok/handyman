import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hdman/config/index.dart';
import 'package:hdman/function/alert.dart';
import 'package:hdman/provider/model/market.dart';
import 'package:hdman/provider/model/user.dart';
import 'package:hdman/widget/TextFix.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final name = TextEditingController();
  final price = TextEditingController();
  String service;
  List ProductItems = [];

  Future actionUser() async {
    final market = Provider.of<MarketProvider>(context, listen: false).data;

    Dio dio = new Dio();
    Response response = await dio.get("${api}/product/${market["id"]}");

    print("actionUser start !");
    print(response.data["data"]);
    print("====");

    if (response.data["bypass"]) {
      setState(() {
        ProductItems = response.data["data"];
      });
    } else {
      setState(() {
        ProductItems = [];
      });
    }
  }

  didChangeDependencies() {
    super.didChangeDependencies();
    actionUser();
  }

  Future<void> actionCreate() async {
    final user = Provider.of<UserProvider>(context, listen: false).data;
    final market = Provider.of<MarketProvider>(context, listen: false).data;

    try {
      if (name.text != "" && price != null && service != null) {
        Dio dio = new Dio();
        Response response = await dio.post("${api}/product/create", data: {
          "id_market": market["id"],
          "name": name.text,
          "price": price.text,
          "service": service,
          "detail": ""
        });

        if (response.data["bypass"]) {
          setState(() {
            ProductItems = response.data["data"];
          });

          getAlertWarning(context, "สร้างรายการสำเร็จ !");
        } else {
          getAlertWarning(context, "ไม่สามารถสร้างรายการได้ !");
        }
      } else {
        getAlertWarning(context, "กรุณากรอกข้อมูลให้ครบ !");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> actionDelete(direction, index) async {
    try {
      print("actionDelete !");
      if (direction.toString() == "DismissDirection.endToStart") {
        final market = Provider.of<MarketProvider>(context, listen: false).data;

        Dio dio = new Dio();
        Response response = await dio.post("${api}/product/delete",
            data: {"id": ProductItems[index]["id"], "id_market": market["id"]});
        print(response.data);
        if (response.data["bypass"]) {
          setState(() {
            ProductItems = response.data["data"];
          });

          getAlertWarning(context, "ลบรายการสำเร็จ !");
        } else {
          getAlertWarning(context, "ไม่สามารถลบรายการได้ !");
        }
      } else {
        getAlertError(context, "ไม่สามารถลบรายการได้ !");
      }
    } catch (e) {
      print(e);
    }
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
            TextFix(
              title: "ลบ",
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: ProductItems.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildCards(index);
      },
    );
  }

  Widget _buildCards(index) {
    return GestureDetector(
      onTap: () => {},
      child: Dismissible(
        background: slideLeftBackground(),
        confirmDismiss: (DismissDirection direction) async {
          actionDelete(direction, index);
        },
        direction: DismissDirection.endToStart,
        key: Key(index.toString()),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            child: FloatingActionButton(
              heroTag: null,
              key: Key(index.toString()),
              backgroundColor: Colors.redAccent,
              elevation: 0,
              child: Icon(
                Icons.local_activity,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
          title: TextFix(
            title: ProductItems[index]["name"],
          ),
          subtitle: TextFix(
            title:
                "${ProductItems[index]["price"]} บาท ${ProductItems[index]["service"]}",
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem> Dropdownitems = [
    DropdownMenuItem(
      child: TextFix(
        title: '/ชั่วโมง',
      ),
      value: '/ชั่วโมง',
    ),
    DropdownMenuItem(
      child: TextFix(
        title: '/งาน',
      ),
      value: '/งาน',
    ),
  ];

  Widget _buildDropdownFix() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: SearchableDropdown.single(
        style: TextStyle(fontFamily: getFontFamily, fontSize: 18),
        items: Dropdownitems,
        clearIcon: Icon(
          Icons.close,
          color: Colors.white,
        ),
        value: service,
        hint: "เลือกอัตราค่าบริการต่อ / ???",
        searchHint: "อัตราค่าบริการต่อ / ???",
        onChanged: (value) {
          setState(() {
            service = value.toString();
          });
        },
        onClear: () {
          setState(() {
            service = null;
          });
        },
        isExpanded: true,
      ),
    );
  }

  Widget _buildTextField(title, textEdit, icon, type) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: TextField(
        controller: textEdit,
        onChanged: (text) => {},
        style: TextStyle(fontFamily: getFontFamily),
        keyboardType: type,
        decoration: InputDecoration(
            icon: icon,
            border: OutlineInputBorder(),
            hintStyle: TextStyle(fontFamily: getFontFamily),
            labelText: title,
            labelStyle: TextStyle(fontFamily: getFontFamily)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextFix(
          title: 'เพิ่มรายการที่ให้บริการ',
          sizefont: sizeFontHeader,
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 25,
            ),
            _buildTextField(
                "ชื่อการบริการ", name, Icon(Icons.note), TextInputType.text),
            SizedBox(
              height: 15,
            ),
            _buildTextField(
                "ราคา", price, Icon(Icons.attach_money), TextInputType.number),
            SizedBox(
              height: 15,
            ),
            _buildDropdownFix(),
            SizedBox(
              height: 15,
            ),
            FlatButton(
              onPressed: () => actionCreate(),
              child: TextFix(
                title: 'เพิ่มข้อมูล',
                sizefont: 18,
              ),
            ),
            Divider(
              height: 5,
              color: Colors.white,
              endIndent: 15,
              indent: 15,
            ),
            SizedBox(
              height: 15,
            ),
            TextFix(
              title: "รายการที่ร้านให้บริการ",
              sizefont: 18,
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: _buildListView(),
            )
          ],
        ),
      ),
    );
  }
}
