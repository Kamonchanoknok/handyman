import 'package:flutter/material.dart';
import 'package:hdman/config/index.dart';
import 'package:hdman/provider/model/user.dart';
import 'package:hdman/widget/TextFix.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  /*
  
  */

  void openMarket(context) {}

  List items = [
    {'title': 'เปิดร้านของคุณ', 'screen': '/market'},
    {'title': 'คู่มือการใช้งาน', 'screen': '/manual'},
  ];

  void selectFuncList(name) {
    Navigator.of(context).pushNamed(name);
  }

  Widget _buildListView() {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildListTitles(index);
      },
      separatorBuilder: (context, index) {
        return Divider(
          thickness: 0.5,
          height: 1,
          endIndent: 20,
          indent: 20,
        );
      },
    );
  }

  Widget _buildListTitles(int index) {
    return ListTile(
      title: TextFix(
        title: items[index]['title'],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 15,
      ),
      onTap: () => selectFuncList(items[index]['screen']),
    );
  }

  Widget _buildProfile() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/profile_edit');
          },
          child: Container(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.account_circle,
                  size: MediaQuery.of(context).size.width / 4,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFix(
                  title: Provider.of<UserProvider>(context)
                      .data['username']
                      .toString(),
                  sizefont: 18.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFix(
          title: 'โปรไฟล์ส่วนตัว',
          sizefont: sizeFontHeader,
        ),
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        child: Column(
          children: <Widget>[
            _buildProfile(),
            SizedBox(
              height: 10,
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
