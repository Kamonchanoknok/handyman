import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hdman/config/index.dart';
import 'package:hdman/provider/model/user.dart';
import 'package:hdman/widget/TextFix.dart';
import 'package:provider/provider.dart';

class BillScreen extends StatefulWidget {
  BillScreen({Key key}) : super(key: key);

  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  List historyList = [];
  List doprocessList = [];
  bool loadingChecked = true;

  didChangeDependencies() {
    super.didChangeDependencies();

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    actionDoProcess(userProvider.data["id"]);
    actionGetHistory(userProvider.data["id"]);
  }

  Future<void> actionDoProcess(id) async {
    try {
      Dio dio = new Dio();
      Response response =
          await dio.get("${api}/history/doprocess/${id.toString()}");

      setState(() {
        doprocessList = response.data["data"];
      });
    } catch (e) {
      //เกิด error ระหว่างโหลด

    }
  }

  Future<void> actionGetHistory(id) async {
    try {
      Dio dio = new Dio();
      Response response = await dio.get("${api}/history/${id.toString()}");

      setState(() {
        historyList = response.data["data"];
        loadingChecked = false;
      });
    } catch (e) {
      //เกิด error ระหว่างโหลด

    }
  }

  Widget _buildCardsDoProcess(index) {
    return Card(
      elevation: 3,
      child: GestureDetector(
        onTap: () {},
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            child: FloatingActionButton(
              heroTag: null,
              key: Key(index.toString()),
              backgroundColor: Colors.blueAccent,
              elevation: 0,
              child: Icon(
                Icons.cached,
              ),
              onPressed: () {},
            ),
          ),
          title: TextFix(
            title: historyList[index]["product_name"],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFix(
                title: "จากร้าน ${doprocessList[index]["market_name"]}",
              ),
              TextFix(
                title: "สถานะ ${doprocessList[index]["status_name"]}",
              ),
              doprocessList[index]["status_name_sub"] != null
                  ? TextFix(
                      title: "${doprocessList[index]["status_name_sub"]}",
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListHistory() {
    return ListView.builder(
      itemCount: historyList.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildCardsHistory(index);
      },
    );
  }

  Widget _buildCardsHistory(index) {
    return Card(
      elevation: 3,
      child: GestureDetector(
        onTap: () {},
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            child: FloatingActionButton(
              heroTag: null,
              key: Key(index.toString()),
              backgroundColor:
                  historyList[index]["status"] == 4 ? Colors.green : Colors.red,
              elevation: 0,
              child: historyList[index]["status"] == 4
                  ? Icon(
                      Icons.check,
                    )
                  : Icon(
                      Icons.close,
                    ),
              onPressed: () {},
            ),
          ),
          title: TextFix(
            title: historyList[index]["product_name"],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFix(
                title: "จากร้าน ${historyList[index]["market_name"]}",
              ),
              TextFix(
                title: "สถานะ ${historyList[index]["status_name"]}",
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScrenns() {
    if (loadingChecked) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[CircularProgressIndicator()],
      ));
    } else {
      if (historyList.length == 0) {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.cloud_off,
              size: MediaQuery.of(context).size.width / 3,
            ),
            TextFix(
              title: "ไม่พบข้อมูล !",
              sizefont: 18,
            )
          ],
        ));
      } else {
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              doprocessList.length != 0 ? _buildCardsDoProcess(0) : Container(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFix(
                  title: "ล่าสุด",
                  sizefont: 16,
                  color: Colors.black,
                ),
              ),
              Expanded(child: _buildListHistory()),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFix(
          title: 'รายการ',
          sizefont: sizeFontHeader,
        ),
      ),
      body: _buildScrenns(),
    );
  }
}
