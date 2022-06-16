// ignore_for_file: prefer_const_constructors;, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:corpo/http/consultas.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetalleVigenciaPage extends StatefulWidget {
  const DetalleVigenciaPage(this.municipio, this.periodoSeleccionado,{Key? key}) : super(key: key);
  final String municipio;
  final String periodoSeleccionado;
  @override
  State<DetalleVigenciaPage> createState() => _DetalleVigenciaPageState();
}

class _DetalleVigenciaPageState extends State<DetalleVigenciaPage> {
 
  ServicioHttp service = ServicioHttp();
  dynamic total;
  List totalPorMes = List.empty();
  bool proceso = true;
  final oCcy = NumberFormat("#,##0.00", "en_US");
  
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
                    totalPorMes.isNotEmpty ? Container(
                      padding: EdgeInsets.only(bottom: 210),
                      color: Colors.transparent,
                      height: size.height - size.height * 0.1,
                      child: ListView.builder(
                        itemCount: totalPorMes.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return itemCard(totalPorMes[index]);
                        }
                      )
                    ): Container(
                      padding: EdgeInsets.only(top: 130),
                      child: Center(child: CircularProgressIndicator()),
                    ) ,
                  ]
                )
              )
            )
          )
        )
      ]
    );
  }

  Widget itemCard(dynamic item){
    return Container(
      height: 120.0,
      margin: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: Stack(
        children: [
          Container(
            height: 124.0,
            width: 280,
            margin: EdgeInsets.only(left: 46.0),
            padding: EdgeInsets.only(top: 25, left: 40),
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
                Text('Avaluo : \$ ${oCcy.format(item["avaluo"]).replaceAll(".00", "")}', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Declarado : \$ ${oCcy.format(double.parse(item["total"])).replaceAll(".00", "")}', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("Tarifa : "+item["tarifa"].toString(), style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Container(
            margin:  EdgeInsets.symmetric(vertical: 16.0),
            alignment: FractionalOffset.centerLeft,
            child: Image(
              image: AssetImage("assets/"+item["numero_mes"].toString()+".png"),
              height: 82.0,
              width: 82.0,
            ),
          )
        ],
      )
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
      proceso = false;
    });
  }

}