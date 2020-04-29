import 'package:flutter/material.dart';
import 'package:hdman/config/index.dart';
import 'package:hdman/provider/model/market.dart';
import 'package:provider/provider.dart';

class TextFix extends StatelessWidget {
  final String title;
  final double sizefont;
  final Color color;

  const TextFix({Key key, this.title, this.sizefont, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final marketProvider = Provider.of<MarketProvider>(context, listen: false);
    return Text(
      title,
      style: TextStyle(
        fontFamily: getFontFamily,
        fontSize: sizefont != null ? sizefont : 14,
        color: marketProvider.color
            ? Colors.white
            : color == null ? colorsText_Pri : color,
      ),
    );
  }
}
