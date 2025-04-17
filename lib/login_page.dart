import 'package:database_app/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  TextEditingController userName=TextEditingController();
  TextEditingController passWord=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
appBar: AppBar(
  backgroundColor: Colors.green,
  title: Center(
    child: Text('Sign Up',style: TextStyle(fontSize: 30,
        color: Colors.black,fontWeight: FontWeight.bold),),
  ),

),
body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
   // crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(height: 220,),
      SizedBox(
        width: 200,
        child: TextField(
          controller:userName ,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: "UserName",
            hintStyle: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold,
            fontSize: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(21)
            ),
            focusedBorder:OutlineInputBorder(
              borderRadius: BorderRadius.circular(21),
              borderSide: BorderSide(
                color: Colors.green,
                width: 3
              )
            ),

          ),
        ),
      ),
      SizedBox(height: 20,),
      SizedBox(
        width: 200,
        child: TextField(
          controller:passWord ,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: "Password",
            hintStyle: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(21)
            ),
            focusedBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(21),
                borderSide: BorderSide(
                    color: Colors.green,
                    width: 3
                )
            ),

          ),
        ),
      ),
      SizedBox(height: 20,),
      ElevatedButton(onPressed: ()async{
        var sharedPref= await SharedPreferences.getInstance();
        sharedPref.setBool(SplashScreenState.KEYLOGIN, true);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));

      },
          child: Text("Login",style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),),
        // autofocus: true,
      ),
    ],
  ),
),
    );
  }
}
