import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdman/components/auth/login.dart';
import 'package:hdman/components/auth/register.dart';
import 'package:hdman/components/auth/verify.dart';
import 'package:hdman/components/screens/home/index.dart';
import 'package:hdman/components/screens/manual/index.dart';
import 'package:hdman/components/screens/profile/edit.dart';
import 'package:hdman/components/screens/stores/product.dart';
import 'package:hdman/splash.dart';

import 'components/screens/market/index.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/home':
        return CupertinoPageRoute(builder: (context) => HomeScreen());

      case '/login':
        return CupertinoPageRoute(builder: (context) => LoginScreen());

      case '/register':
        return CupertinoPageRoute(builder: (context) => RegisterScreen());

      case '/verify':
        if (args is Map<String, dynamic>) {
          return CupertinoPageRoute(
              builder: (context) => VerifyScreen(
                    email: args['email'],
                  ));
        }

        return CupertinoPageRoute(builder: (context) => VerifyScreen());

      case '/profile_edit':
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return EditProfileScreen();
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0.0, 0.5),
                end: Offset(0.0, 0.0),
              ).animate(CurvedAnimation(
                  parent: animation, curve: Curves.linearToEaseOut)),
              child: child,
            );
          },
        );

      case '/splash':
        return CupertinoPageRoute(builder: (context) => Splash());

      case '/product':
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return ProductScreen();
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0.0, 0.5),
                end: Offset(0.0, 0.0),
              ).animate(CurvedAnimation(
                  parent: animation, curve: Curves.linearToEaseOut)),
              child: child,
            );
          },
        );

      case '/manual':
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return ManualScreen();
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0.0, 0.5),
                end: Offset(0.0, 0.0),
              ).animate(CurvedAnimation(
                  parent: animation, curve: Curves.linearToEaseOut)),
              child: child,
            );
          },
        );

      case '/market':
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return MarketScreen();
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0.0, 0.5),
                end: Offset(0.0, 0.0),
              ).animate(CurvedAnimation(
                  parent: animation, curve: Curves.linearToEaseOut)),
              child: child,
            );
          },
        );

      default:
    }
  }
}
