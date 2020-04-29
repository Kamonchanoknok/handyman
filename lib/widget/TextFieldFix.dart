import 'package:flutter/material.dart';
import 'package:hdman/config/index.dart';

class TextFieldFix extends StatelessWidget {
  final String title;
  final bool obscure_mode;
  final TextEditingController textEdit;

  const TextFieldFix({Key key, this.title, this.obscure_mode, this.textEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: TextField(
        controller: textEdit,
        onChanged: (text) => {},
        obscureText: obscure_mode ? true : false,
        style: TextStyle(fontFamily: getFontFamily),
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintStyle: TextStyle(fontFamily: getFontFamily),
            labelText: title,
            labelStyle: TextStyle(fontFamily: getFontFamily)),
      ),
    );
  }
}
