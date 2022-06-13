// ignore_for_file: prefer_const_constructors

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity, 
          padding: EdgeInsets.only(top: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text("INFORME GENERAL", style: TextStyle(color: Colors.blueAccent, fontSize: 30, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("5 municipios con mayor declaración", style: TextStyle(color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                Text("(en millones)", style: TextStyle(color: Colors.blueAccent, fontSize: 15, fontWeight: FontWeight.bold)),
                SimpleBarChartPage("general1", animate: true),
                Text("5 municipios con menor declaración", style: TextStyle(color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                Text("(en millones)", style: TextStyle(color: Colors.blueAccent, fontSize: 15, fontWeight: FontWeight.bold)),
                SimpleBarChartPage("general1.1", animate: true),
                SizedBox(height: 10),
                Text("Declaraciones por vigencia", style: TextStyle(color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                Text("(en millones)", style: TextStyle(color: Colors.blueAccent, fontSize: 15, fontWeight: FontWeight.bold)),
                SimpleBarChartPage("general2", animate: true),
                SizedBox(height: 10),
                Text("5 municipios con mayor declaración", style: TextStyle(color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                Text("(en millones)", style: TextStyle(color: Colors.blueAccent, fontSize: 15, fontWeight: FontWeight.bold)),
                PieChartPage()
              ],
            ),
          ) ,
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();
  }
  
}