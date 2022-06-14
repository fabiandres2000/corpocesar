// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:corpo/http/consultas.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:carousel_slider/carousel_slider.dart';


class MunicipioPage extends StatefulWidget {
  const MunicipioPage({Key? key}) : super(key: key);
  @override
  State<MunicipioPage> createState() => _MunicipioPageState();
}

class _MunicipioPageState extends State<MunicipioPage> {
  ServicioHttp service = ServicioHttp();
  List municipios = List.empty();
  List declaraciones = List.empty();
  List declaracionesPorMes = List.empty();
  List<charts.Series<dynamic, String>> seriesList = List.empty();
  String combosecre = "0";
  String periodoSeleccionado = "";

  final oCcy = NumberFormat("#,##0.00", "en_US");

  bool selected1 = true;
  bool selected2 = false;
  bool selected3 = false;

  bool proceso = true;
  bool proceso2 = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                height: size.height * 0.05,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey)),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: SizedBox(),
                  value: combosecre,
                  items: municipios.isNotEmpty
                      ? municipios
                          .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value['codmun'].toString(),
                            child:
                                Text(value['descripcion'].toString()),
                          );
                        }).toList()
                      : [
                          DropdownMenuItem(
                            child: Text("Seleccione un municipio..."),
                            value: "0",
                          ),
                        ],
                  onChanged: (value) {
                    setState(() {
                      combosecre = value!;
                      consultarDeclaracionesInfo();
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            combosecre != "0" && !proceso?
              Row(
                children: <Widget> [
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () {
                        cambiarSeleccion(1, declaraciones[declaraciones.length-3]["periodo"]);
                      },
                      child:  Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: !selected1 ? Colors.white : Color(0xff0B81E3),
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
                          children: [
                            Text(declaraciones[declaraciones.length-3]["periodo"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: selected1 ? Colors.white: Colors.black)),
                            SizedBox(height: 15),
                            Text('\$ ${oCcy.format(declaraciones[declaraciones.length-3]["total"]).replaceAll(".00", "")}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: selected1 ? Colors.white: Colors.black))
                          ],
                        )
                      )
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child:
                    GestureDetector(
                      onTap: () {
                        cambiarSeleccion(2, declaraciones[declaraciones.length-2]["periodo"]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: !selected2 ? Colors.white : Color(0xff0B81E3),
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
                          children: [
                            Text(declaraciones[declaraciones.length-2]["periodo"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: selected2 ? Colors.white: Colors.black)),
                            SizedBox(height: 15),
                            Text('\$ ${oCcy.format(declaraciones[declaraciones.length-2]["total"]).replaceAll(".00", "")}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: selected2 ? Colors.white: Colors.black))
                          ],
                        )
                      )
                    )
                  ),
                  Expanded(
                    flex: 3,
                    child:
                    GestureDetector(
                      onTap: () {
                        cambiarSeleccion(3, declaraciones[declaraciones.length-1]["periodo"]);
                      },
                      child:  Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: !selected3 ? Colors.white : Color(0xff0B81E3),
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
                          children: [
                            Text(declaraciones[declaraciones.length-1]["periodo"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: selected3 ? Colors.white: Colors.black)),
                            SizedBox(height: 15),
                            Text('\$ ${oCcy.format(declaraciones[declaraciones.length-1]["total"]).replaceAll(".00", "")}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: selected3 ? Colors.white: Colors.black))
                          ],
                        )
                      )
                    ),
                  )
                ],
              )
            : Center(),
            SizedBox(height: 20),
            !proceso2 ? Container(
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
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(7),
              height: 300,
              child:Stack(
                children: [
                  Text("                                    Declaración por mes \n                                        (vigencia: $periodoSeleccionado)", style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                  SizedBox(height: 40),
                  charts.BarChart(
                    seriesList,
                    animate: true,
                    barRendererDecorator: charts.BarLabelDecorator<String>(
                      insideLabelStyleSpec: charts.TextStyleSpec(
                        fontSize: 6,
                        color: charts.MaterialPalette.white
                      ),
                      outsideLabelStyleSpec: charts.TextStyleSpec(
                        fontSize: 6,
                        color: charts.MaterialPalette.black
                      ),
                    ),
                    primaryMeasureAxis:  charts.NumericAxisSpec(
                      renderSpec:  charts.SmallTickRendererSpec(
                        labelStyle:  charts.TextStyleSpec(
                          fontSize: 8,
                          color: charts.MaterialPalette.black,
                        ),
                        lineStyle:  charts.LineStyleSpec(
                          color: charts.MaterialPalette.black
                        ),
                      ),
                      tickProviderSpec: charts.BasicNumericTickProviderSpec(desiredTickCount: 10)
                    ),
                    domainAxis:  charts.OrdinalAxisSpec(
                      renderSpec:  charts.SmallTickRendererSpec(
                        labelOffsetFromAxisPx: 30,
                        labelCollisionRotation: -10,
                        labelStyle:  charts.TextStyleSpec(
                          fontSize: 6,
                          color: charts.MaterialPalette.black,
                        ),
                        lineStyle:  charts.LineStyleSpec(
                          color: charts.MaterialPalette.black
                        ),
                      )
                    ),
                  ),
                ],
              ) 
            ): Container(
              padding: EdgeInsets.only(top: 190),
              child: Center(child: CircularProgressIndicator()),
            )  
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    consultarData();
  }

  consultarData() async {
    var response1 = await service.municipios();
    setState(() {
      municipios = response1["municipios"];
    });
  }

  consultarDeclaracionesInfo() async {
    setState(() {
      proceso = true;
    });
    var response = await service.infoMunicipio(combosecre);
    declaraciones = List.empty();
    setState(() {
      declaraciones = response["declaraciones"];
      proceso = false;
      cambiarSeleccion(1, declaraciones[declaraciones.length-3]["periodo"]);
    });
  }

  cambiarSeleccion(int index, String periodo) async {
   
    setState(() {
      proceso2 = true;
      periodoSeleccionado = periodo;
    });

    switch (index) {
      case 1:
        setState(() {
          selected1 = true;
          selected2 = false;
          selected3 = false;
        });
      break;
      case 2:
        setState(() {
          selected1 = false;
          selected2 = true;
          selected3 = false;
        });
      break;
      case 3:
        setState(() {
          selected1 = false;
          selected2 = false;
          selected3 = true;
        });
      break;
      default:
    }
    var response = await service.infoMunicipioPeriodo(combosecre, periodo);
    setState(() {
      declaracionesPorMes = response["declaraciones"];
      declaracionesPorMes.sort((a, b) => a['numero_mes'].compareTo(b['numero_mes']));
      _createData();
    });
  } 

  _createData() async {

    List<DataSample> data = [];
  
    for (var i = 0; i < declaracionesPorMes.length; i++) {
      var item = declaracionesPorMes[i];
      var dataitem = DataSample(item["meses"].substring(0, 3), item["total"]/1000000);
      data.add(dataitem);
      
    }

    setState(() {
      seriesList = [
        charts.Series<DataSample, String>(
          id: 'Sales',
          colorFn: (DataSample data, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
          domainFn: (DataSample data, _) => data.item,
          measureFn: (DataSample data, _) => data.total,
          data: data,
          labelAccessorFn: (DataSample data, _) =>'\$${data.total.toStringAsFixed(2)}'
        )
      ];
      proceso2 = false;
    });
    
  }
}

class DataSample {
  final String item;
  final double total;

  DataSample(this.item, this.total);
}