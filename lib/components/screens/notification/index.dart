import 'package:flutter/material.dart';
import 'package:hdman/config/index.dart';
import 'package:hdman/widget/TextFix.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFix(
          title: 'การแจ้งเตือน',
          sizefont: sizeFontHeader,
        ),
      ),
    );
  }
}
