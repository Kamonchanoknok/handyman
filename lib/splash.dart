import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hdman/components/screens/home/index.dart';
import 'package:hdman/config/index.dart';
import 'package:hdman/provider/model/market.dart';
import 'package:hdman/provider/model/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

import 'components/auth/login.dart';

class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  /*
   */
  bool login = false;

  Future<Null> loadingData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    final user = prefs.getString("user");
    final colorTheme = prefs.getBool("market");
    final statusMarket = prefs.getBool("market_status");

    MarketProvider marketProvider =   Provider.of<MarketProvider>(context, listen: false);

    if(colorTheme != null){
      marketProvider.setMarket(colorTheme);
    }else{
      marketProvider.setMarket(false);
    }

    if(statusMarket != null ){
      marketProvider.setStatus(statusMarket);
    }else{
      marketProvider.setStatus(false);
    }

    if (user != null) {
      setState(() {
        login = true;
        userProvider.setUser(jsonDecode(user));
      });
    } else {
      print(userProvider.data);
    }
  }

  @override
  void initState() {
    super.initState();
    loadingData();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 5,
        navigateAfterSeconds: login ? HomeScreen() : LoginScreen(),
        title: Text(
          'Welcome In Hdman Application',
          style: TextStyle(fontFamily: getFontFamily),
        ),
        image: Image.asset('lib/assets/images/NO_IMG.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: TextStyle(fontFamily: getFontFamily),
        photoSize: 100.0,
        loaderColor: Colors.red);
  }
}
