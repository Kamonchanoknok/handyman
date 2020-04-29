import 'package:flutter/material.dart';
import 'package:hdman/widget/TextFix.dart';

getAlertSuccess(context, title) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: TextFix(
            title: 'ทำรายการสำเร็จ',
            sizefont: 18,
          ),
          content: TextFix(
            title: title,
            sizefont: 16,
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      });
}

getAlertWarning(context, title) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: TextFix(
            title: 'การทำรายการมีข้อผิดพลาด',
            sizefont: 18,
          ),
          content: TextFix(
            title: title,
            sizefont: 16,
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      });
}

getAlertError(context, title) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: TextFix(
            title: 'การทำรายการมีข้อผิดพลาดแบบรุนแรง',
            sizefont: 18,
          ),
          content: TextFix(
            title: title,
            sizefont: 16,
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      });
}
