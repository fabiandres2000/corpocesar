// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:corpo/componentes/bouncy.dart';
import 'package:corpo/detalles/detalle.dart';
import 'package:flutter/material.dart';
import 'package:corpo/http/consultas.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:carousel_slider/carousel_slider.dart';


class MunicipioPage extends StatefulWidget {
  final String municipio;
  const MunicipioPage(this.municipio, {Key? key}) : super(key: key);
  @override
  State<MunicipioPage> createState() => _MunicipioPageState();
}

class _MunicipioPageState extends State<MunicipioPage> {
  ServicioHttp service = ServicioHttp();
  List municipios = List.empty();
  List declaracionesPorPeriodo = List.empty();
  List declaracionesPorMes = List.empty();
  List<charts.Series<dynamic, String>> seriesList = List.empty();
  String municipioSeleccionado = "0";
  String periodoSeleccionado = "";

  final oCcy = NumberFormat("#,##0.00", "en_US");

  bool proceso = true;
  bool proceso2 = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          body: Container(
            padding: EdgeInsets.only(top: size.height * 0.105),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Seleccione un municipio",style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: size.height * 0.035),
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
                      dropdownColor: Color.fromARGB(255, 12, 78, 139),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      isExpanded: true,
                      underline: SizedBox(),
                      value: municipioSeleccionado,
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
                          municipioSeleccionado = value!;
                          consultarDeclaracionesInfo();
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.055),
                municipioSeleccionado != "0" && !proceso? Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      enableInfiniteScroll: true,
                      reverse: false,
                      viewportFraction: 0.40,
                      height: 90,
                    ),
                    items: itemCarousel(context),
                  ),
                ) 
                : Center(),
                SizedBox(height: size.height * 0.035),
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
                  padding: EdgeInsets.all(10),
                  height: 320,
                  child: Column(
                    children: [
                      Text("Declaración por mes", style: TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("(vigencia: $periodoSeleccionado)", style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                      Text("en millones de pesos", style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold)),        
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                          padding: EdgeInsets.all(0),
                          height: 250,
                          width: 600,
                            child: charts.BarChart(
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
                        ),
                      )
                    ],
                  ) 
                ): Container(
                  padding: EdgeInsets.only(top: 190),
                  child: Center(child: CircularProgressIndicator()),
                ),
                SizedBox(
                  height: size.height * 0.035
                ),
                !proceso2 ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      BouncyPageRoute(widget: DetallePage(municipioSeleccionado, periodoSeleccionado))
                    ); 
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:  Color(0xff0B81E3),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff0B81E3).withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(left: 100, right: 100),
                    padding: EdgeInsets.all(10),
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Ver detalles", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                        Icon(Icons.arrow_right_alt, color: Colors.white),
                      ],
                    ),
                    ) ,
                ): Center(),
              ],
            ),
          ),
        )
      ]
    );
  }

  @override
  void initState() {
    super.initState();
    consultarMunicipios();
  }

  consultarMunicipios() async {
    var response1 = await service.municipios();
    setState(() {
      municipios = response1["municipios"];
      municipioSeleccionado = widget.municipio != "0" ? widget.municipio :"001";
      consultarDeclaracionesInfo();
    });
  }

  consultarDeclaracionesInfo() async {
    setState(() {
      proceso = true;
    });
    var response = await service.infoMunicipio(municipioSeleccionado);
    declaracionesPorPeriodo = List.empty();
    setState(() {
      declaracionesPorPeriodo = response["declaraciones"];
      proceso = false;
      if(declaracionesPorPeriodo.isNotEmpty){
        cambiarSeleccion(declaracionesPorPeriodo[0]["periodo"]);
      }
    });
  }

  cambiarSeleccion(String periodo) async {
   
    setState(() {
      proceso2 = true;
      periodoSeleccionado = periodo;
    });

    setState(() {
      for (var item in declaracionesPorPeriodo) {
        if(item["periodo"] == periodo){
          item["seleccionado"] = 1;
        }else{
          item["seleccionado"] = 0;
        }
      }
    });
    

    var response = await service.infoMunicipioPeriodo(municipioSeleccionado, periodo);
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
          colorFn: (DataSample data, _) => charts.ColorUtil.fromDartColor(Color(0xff0B81E3)),
          domainFn: (DataSample data, _) => data.item,
          measureFn: (DataSample data, _) => data.total,
          data: data,
          labelAccessorFn: (DataSample data, _) =>'\$${data.total.toStringAsFixed(2)}'
        )
      ];
      proceso2 = false;
    });
  }

  List<Widget> itemCarousel(BuildContext context) {
    List<Widget> widgets = [];
    for (var item in declaracionesPorPeriodo) {
      widgets.add( Container(
        width: 150,
        padding: EdgeInsets.all(0),
        child: GestureDetector(
          onTap: () {
            cambiarSeleccion(item["periodo"]);
          },
          child:  Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: item["seleccionado"] == 1 ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment(0.0, 1.0),
                colors:  <Color>[
                  Color.fromARGB(255, 136, 124, 226),
                  Color.fromARGB(255, 108, 92, 231),
                ], // red to yellow
                tileMode: TileMode.repeated, 
              ): LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment(0.0, 1.0), 
                colors:  <Color>[
                  Color.fromARGB(255, 255, 252, 252),
                  Color.fromARGB(255, 255, 255, 255),
                ], // red to yellow
                tileMode: TileMode.repeated, 
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(7),
            child: Column(
              children: [
                Text(item["periodo"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: item["seleccionado"] != 0  ? Colors.white: Colors.black)),
                SizedBox(height: 15),
                Text('\$ ${oCcy.format(item["total"]).replaceAll(".00", "")}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: item["seleccionado"] != 0  ? Colors.white: Colors.black))
              ],
            )
          )
        ),
      ));
    }
    return widgets;
  }
}

class DataSample {
  final String item;
  final double total;

  DataSample(this.item, this.total);
}