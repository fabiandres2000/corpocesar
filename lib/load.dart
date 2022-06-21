// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:corpo/componentes/bouncy.dart';
import 'package:corpo/login.dart';
import 'package:flutter/material.dart';

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
            width: 128,
            height: 128,
          )
        ),
      )
    );
  }

    @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), ir);
  }

  ir(){
    Navigator.push(
      context,
      BouncyPageRoute(widget: LoginPage())
    ); 
  }
  
}