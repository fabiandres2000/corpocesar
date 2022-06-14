// ignore_for_file: prefer_const_constructors, prefer_collection_literals

import 'dart:math' as math;

import 'package:corpo/http/consultas.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartPage extends StatefulWidget {
  const PieChartPage({Key? key}) : super(key: key);

  @override
  PieChartPageState createState() => PieChartPageState();
}

class PieChartPageState extends State<PieChartPage> {
  ServicioHttp service = ServicioHttp();
  List porMunicipio = List.empty();
  List porVigencia = List.empty();

  Map<String, double> dataMap = Map();

  bool proceso = true;

  final colorList = <Color>[
    const Color(0xff109618),
    const Color(0xff0C4E8B),
    const Color(0xff0BB68C),
    const Color(0xff0B81E3),
    const Color(0xff6c5ce7),
  ];

  @override
  Widget build(BuildContext context) {
    int key = 0;
    return Container(
      padding: EdgeInsets.all(5),
      height: 300,
      width: double.infinity,
      child: !proceso ? PieChart(
        legendOptions: LegendOptions(
          showLegends: true,
          legendTextStyle: TextStyle(fontSize: 9)
        ),
        key: ValueKey(key),
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 800),
        chartRadius: math.min(MediaQuery.of(context).size.width / 1.6, 300),
        colorList: colorList,
        chartValuesOptions: ChartValuesOptions(
          chartValueStyle: TextStyle(fontSize: 8, color: Colors.black)
        ),
      ): Center(child: CircularProgressIndicator())
    );
  }

   @override
  void initState() {
    super.initState();
    createData();
  }

  createData() async {
    setState(() {
      proceso = true;
    });
    await consultarData();
    setState(() {
      for (var i = 0; i < 5; i++) {
        var item = porMunicipio[i];
        dataMap.putIfAbsent(item["municipio_nombre"], () => item["total"]/1000000);
      }
      proceso = false;
    });
    
  }

  consultarData() async {
    var response1 = await service.declaracionesMunicipio();
    var response2 = await service.declaracionesVigencia();
    setState(() {
      porMunicipio = response1["declaraciones"];
      porVigencia = response2["declaraciones"];
    });
  }
}