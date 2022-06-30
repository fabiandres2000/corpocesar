// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:corpo/componentes/bouncy.dart';
import 'package:corpo/principal/home.dart';
import 'package:corpo/principal/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({Key? key}) : super(key: key);
  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(
          gradient:  LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff0C4E8B),
              Color.fromARGB(255, 23, 133, 105)
            ],
          )
        ),
        child: Align(
          alignment: Alignment.center,
          child: Image.asset(
            "assets/app_logo.gif",
            width: 500,
            height: 800,
          )
        ),
      )
    );
  }

    @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 6000), ir);
  }


  ir() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');

    if(email == null || email == "sgp"){
      Navigator.push(
        context,
        BouncyPageRoute(widget: LoginPage())
      ); 
    }else{
      Navigator.push(
        context,
        BouncyPageRoute(widget: MyHomePage())
      ); 
    }
    
  }
  
}