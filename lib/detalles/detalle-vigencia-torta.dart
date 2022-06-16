// ignore_for_file: prefer_const_constructors;, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_collection_literals
import 'package:corpo/http/consultas.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:math' as math;


class DetalleVigenciaTortaPage extends StatefulWidget {
  const DetalleVigenciaTortaPage(this.municipio, this.periodoSeleccionado,{Key? key}) : super(key: key);
  final String municipio;
  final String periodoSeleccionado;
  @override
  State<DetalleVigenciaTortaPage> createState() => _DetalleVigenciaTortaPageState();
}

class _DetalleVigenciaTortaPageState extends State<DetalleVigenciaTortaPage> {
 
  ServicioHttp service = ServicioHttp();
  dynamic total;
  List totalPorMes = List.empty();
  bool proceso = true;
  final oCcy = NumberFormat("#,##0.00", "en_US");
  Map<String, double> dataMap = Map();

  final colorList = <Color>[
    const Color(0xff5499C7),
    const Color(0xff1ABC9C),
    const Color(0xffEB984E),
    const Color(0xffF1C40F),
    const Color(0xffC39BD3),
    const Color(0xff943126),
    const Color(0xff633974),
    const Color(0xff154360),
    const Color(0xff27AE60),
    const Color(0xffE74C3C),
    const Color(0xff5D6D7E),
    const Color(0xffF0B27A),
  ];

  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int key = 0;
    return Stack(
      children: <Widget>[
        Image.asset(
          "assets/background2.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ), 
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Container(
              padding: const EdgeInsets.only(left: 30),
              child: const Text(""),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity, 
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    !proceso ? Text(total["municipio_nombre"], style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)): Center(),
                    !proceso ? Text('\$ ${oCcy.format(total["total"]).replaceAll(".00", "")}', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)): Center(),
                    Text("( Vigencia - "+widget.periodoSeleccionado+" )", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                    SizedBox(height: size.height * 0.08),
                    Container(
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
                    )
                  ]
                )
              )
            )
          )
        )
      ]
    );
  }

   @override
  void initState() {
    super.initState();
    consultarTotalInfo();
  }
  
  consultarTotalInfo() async {
    setState(() {
      proceso = true;
    });
    var response = await service.totalVigencia(widget.municipio, widget.periodoSeleccionado);
    setState(() {
      total = response["total"][0];
      proceso = false;
      consultarTotaPorMeslInfo();
    });
  }

   consultarTotaPorMeslInfo() async {
    setState(() {
      proceso = true;
    });
    var response = await service.totalPorMesVigencia(widget.municipio, widget.periodoSeleccionado);
    totalPorMes = List.empty();
    setState(() {
      totalPorMes = response["declaraciones"];
       for (var i = 0; i < totalPorMes.length; i++) {
        var item = totalPorMes[i];
        dataMap.putIfAbsent(item["meses"], () => double.parse(item["total"]));
      }
      proceso = false;
    });
  }
}