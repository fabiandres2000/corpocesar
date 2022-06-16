// ignore_for_file: prefer_const_constructors;, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_collection_literals, prefer_final_fields
import 'package:corpo/http/consultas.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_echart/flutter_echart.dart';


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

  List<EChartPieBean> _dataList = [];
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

  String mesS = "Seleccione";
  String avaluoS = "0.00";
  String totalS = "0.00";
  String tarifaS = "Seleccione";
  
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
                      padding: EdgeInsets.only(top: 30, left: 80, right: 80),
                      height: 300,
                      width: double.infinity,
                      child: !proceso ? PieChatWidget(
                        dataList: _dataList, 
                        isLog: false,
                        isBackground: true,
                        isLineText: true,
                        bgColor: Colors.white,
                        isFrontgText: false,
                        initSelect: 0,
                        openType: OpenType.ANI,
                        loopType: LoopType.DOWN_LOOP,
                        clickCallBack: (int value) {
                          setState(() {
                            mesS = totalPorMes[value]["meses"];
                            avaluoS = totalPorMes[value]["avaluo"].toString();
                            tarifaS = totalPorMes[value]["tarifa"].toString();
                            totalS = totalPorMes[value]["total"];
                          });
                        },
                      ): Center(child: CircularProgressIndicator())
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 130.0,
                      width: 280,
                      margin: EdgeInsets.only(left: 0),
                      padding: EdgeInsets.only(top: 15, left: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient:  LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment(0.0, 1.0),
                          colors:  <Color>[
                            Color.fromARGB(255, 255, 255, 255),
                            Color.fromARGB(255, 255, 255, 255),
                          ], // red to yellow
                          tileMode: TileMode.repeated, 
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(  
                            color: Color.fromARGB(122, 87, 87, 87),
                            blurRadius: 17.0,
                            offset: Offset(0.0, 3.0),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Mes : "+mesS, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                           SizedBox(height: 8),
                          Text('Avaluo : \$ ${oCcy.format(double.parse(avaluoS)).replaceAll(".00", "")}', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Declarado : \$ ${oCcy.format(double.parse(totalS)).replaceAll(".00", "")}', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text("Tarifa : "+tarifaS, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                        ],
                      ),
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
        _dataList.add( 
          EChartPieBean(title: item["meses"].substring(0, 3), number: int.parse(item["total"].replaceAll(".00", "")), color: colorList[i], isClick: true),
        );
      }
      proceso = false;
    });
  }
}