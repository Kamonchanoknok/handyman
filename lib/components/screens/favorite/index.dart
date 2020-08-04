import 'package:flutter/material.dart';
import 'package:hdman/config/index.dart';
import 'package:hdman/widget/TextFix.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFix(
          title: 'รายการโปรด',
          sizefont: sizeFontHeader,
        ),
      ),
    );
  }
}
