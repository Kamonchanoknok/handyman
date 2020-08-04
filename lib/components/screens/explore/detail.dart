import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hdman/components/screens/explore/confirm.dart';
import 'package:hdman/components/screens/explore/index.dart';
import 'package:hdman/components/screens/home/index.dart';
import 'package:hdman/config/index.dart';
import 'package:hdman/function/alert.dart';
import 'package:hdman/provider/model/user.dart';
import 'package:hdman/widget/TextFix.dart';
import 'package:provider/provider.dart';

class DetailStoreScreen extends StatefulWidget {
  final String nameStroe;
  final int idStore;

  DetailStoreScreen({Key key, this.idStore, this.nameStroe}) : super(key: key);

  @override
  _DetailStoreScreenState createState() => _DetailStoreScreenState();
}

class _DetailStoreScreenState extends State<DetailStoreScreen> {
  List ProductList = [];
  bool loadingCkecked = true;

  didChangeDependencies() {
    super.didChangeDependencies();
    actionProductList();
  }

  Future<void> actionProductList() async {
    // เรียกข้อมูลร้านที่เปิดทำการ

    try {
      Dio dio = new Dio();
      Response response = await dio.get("${api}/product/${widget.idStore}");

      setState(() {
        ProductList = response.data["data"];
        loadingCkecked = false;
      });
    } catch (e) {
      //เกิด error ระหว่างโหลด

    }
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: ProductList.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildCards(index);
      },
    );
  }

  Widget _buildCards(index) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        elevation: 3,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExploreConfirmScreen(
                  data: ProductList[index],
                ),
              ),
            );
          },
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
                  Icons.settings,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ),
            title: TextFix(
              title: ProductList[index]["name"],
            ),
            subtitle: TextFix(
              title:
                  "${ProductList[index]["price"]} ${ProductList[index]["service"]}",
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrenns() {
    if (loadingCkecked) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[CircularProgressIndicator()],
      ));
    } else {
      if (ProductList.length == 0) {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.cloud_off,
              size: MediaQuery.of(context).size.width / 3,
            ),
            TextFix(
              title: "ไม่พบข้อมูลร้านค้า !",
              sizefont: 18,
            )
          ],
        ));
      } else {
        return _buildListView();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              getAlertSuccess(context,
                  "เพิ่มร้าน ${widget.nameStroe} เป็นรายการโปรด เรียบร้อย !");
            },
          )
        ],
        title: TextFix(
          title: "${widget.nameStroe}",
        ),
      ),
      body: _buildScrenns(),
    );
  }
}
