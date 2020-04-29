import 'package:flutter/material.dart';
import 'package:hdman/config/index.dart';
import 'package:hdman/widget/TextFix.dart';

class BillScreen extends StatefulWidget {
  BillScreen({Key key}) : super(key: key);

  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFix(
          title: 'รายการ',
          sizefont: sizeFontHeader,
        ),
      ),
    );
  }
}
