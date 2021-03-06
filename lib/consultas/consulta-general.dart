// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:corpo/graficos/general1.dart';
import 'package:corpo/graficos/grafico_torta.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class GeneralPage extends StatefulWidget {
  const GeneralPage({Key? key}) : super(key: key);
  @override
  State<GeneralPage> createState() => _GeneralPagePageState();
}

class _GeneralPagePageState extends State<GeneralPage> {
  
  
  List<charts.Series<dynamic, String>> seriesList = List.empty();
  @override
  Widget build(BuildContext context) {   
    return Stack(
      children: <Widget>[
        Image.asset(
          "assets/background.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ), 
        Scaffold(
          appBar:PreferredSize(
          preferredSize: Size.fromHeight(70.0), // here the desired height
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
              title: Container(
                padding: const EdgeInsets.only(left: 0),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text("SGP CORPOCESAR", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      Text("INFORME GENERAL", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
            )
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity, 
              padding: EdgeInsets.only(top: 00),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(7),
                      child: Column(
                        children: <Widget>[
                          Text("      Top 5 municipios \n con mayor declaraci??n", style: TextStyle(color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("(en millones)", style: TextStyle(color: Colors.blueAccent, fontSize: 15, fontWeight: FontWeight.bold)),
                          SimpleBarChartPage("general1", animate: true),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(7),
                      child: Column(
                        children: <Widget>[
                          Text("      Top 5 municipios \n con mayor declaraci??n", style: TextStyle(color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("(en millones)", style: TextStyle(color: Colors.blueAccent, fontSize: 15, fontWeight: FontWeight.bold)),
                          PieChartPage()
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(7),
                      child: Column(
                        children: <Widget>[
                          Text("      Top 5 municipios \n con menor declaraci??n", style: TextStyle(color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("(en millones)", style: TextStyle(color: Colors.blueAccent, fontSize: 15, fontWeight: FontWeight.bold)),
                          SimpleBarChartPage("general1.1", animate: true),
                        ],
                      ),
                    ), 
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(7),
                      child: Column(
                        children: <Widget>[
                          Text("Declaraciones por vigencia", style: TextStyle(color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("(en millones)", style: TextStyle(color: Colors.blueAccent, fontSize: 15, fontWeight: FontWeight.bold)),
                          SimpleBarChartPage("general2", animate: true),
                        ],
                      ),
                    ),  
                  ],
                ),
              ) ,
            ),
          )
      )
    ]);
  }

  @override
  void initState() {
    super.initState();
  }
  
}