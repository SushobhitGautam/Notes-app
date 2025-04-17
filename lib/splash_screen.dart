import 'dart:async';

import 'package:database_app/home_page.dart';
import 'package:database_app/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  static const String KEYLOGIN=" login";
  @override
  void initState() {
    super.initState();
    whereToGo();
  }
  void whereToGo()async{
    var sharedPref= await SharedPreferences.getInstance();
   var isLoggedIn= sharedPref.getBool(KEYLOGIN);
  Timer(Duration(seconds: 4),(){
    if(isLoggedIn!=null){
      if(isLoggedIn){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
      }
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
    }
  });
  }
  @override
  Widget  build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: 170,
          height: 170,
          child: Image.asset("assets/images/notes.png",fit: BoxFit.cover,),
        ),
      ),
    );
  }
}
