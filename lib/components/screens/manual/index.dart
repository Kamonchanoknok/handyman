import 'package:flutter/material.dart';
import 'package:hdman/config/index.dart';
import 'package:hdman/widget/TextFix.dart';

class ManualScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextFix(
          title: 'คู่มือการใช้งาน',
          sizefont: sizeFontHeader,
        ),
      ),
    );
  }
}
