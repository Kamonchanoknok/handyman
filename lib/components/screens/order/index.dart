import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hdman/components/screens/order/detail.dart';
import 'package:hdman/config/index.dart';
import 'package:hdman/function/alert.dart';
import 'package:hdman/provider/model/market.dart';
import 'package:hdman/widget/TextFix.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List historyList = [];
  bool loadingChecked = true;

  didChangeDependencies() {
    super.didChangeDependencies();

    final marketProvider = Provider.of<MarketProvider>(context, listen: false);

    actionOrderMt(marketProvider.data["id"]);
  }

  Future<void> actionOrderMt(id) async {
    try {
      Dio dio = new Dio();
      Response response =
          await dio.get("${api}/history/order/${id.toString()}");

      setState(() {
        historyList = response.data["data"];
        loadingChecked = false;
      });
    } catch (e) {
      //เกิด error ระหว่างโหลด

    }
  }

  Widget _buildIconOrders(status) {
    if (status == 4) {
      return Icon(
        Icons.check,
      );
    } else if (status == 5) {
      return Icon(
        Icons.close,
      );
    } else if (status == 0) {
      return Icon(
        Icons.alarm,
      );
    } else {
      return Icon(
        Icons.cached,
      );
    }
  }

  Color _buildColorOrders(status) {
    if (status == 4) {
      return Colors.green;
    } else if (status == 5) {
      return Colors.red;
    } else {
      return Colors.blueAccent;
    }
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
        onTap: () {
          print(historyList[index]["status"]);
          if (historyList[index]["status"] == 4 ||
              historyList[index]["status"] == 5) {
            getAlertWarning(context,
                'รายการนี้ดำเนินการถึงขั้นสุดท้ายแล้ว ไม่สามารถดูรายละเอียดได้ ');
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailOrderScreen(
                idUser: historyList[index]["account_id"],
                idHistory: historyList[index]["id"],
                data: historyList[index],
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
              backgroundColor: _buildColorOrders(historyList[index]["status"]),
              elevation: 0,
              child: _buildIconOrders(historyList[index]["status"]),
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
                title: "สถานะ ${historyList[index]["status_name"]}",
              ),
              historyList[index]["status_name_sub"] != null
                  ? TextFix(
                      title: "${historyList[index]["status_name_sub"]}",
                    )
                  : Container()
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
          child: _buildListHistory(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFix(
          title: 'ออเเดอร์',
          sizefont: sizeFontHeader,
        ),
      ),
      body: _buildScrenns(),
    );
  }
}
