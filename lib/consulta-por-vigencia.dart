// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables

import 'package:corpo/componentes/bouncy.dart';
import 'package:corpo/detalles/detalle.dart';
import 'package:flutter/material.dart';
import 'package:corpo/http/consultas.dart';
import 'package:intl/intl.dart';

class VigenciaPage extends StatefulWidget {
  const VigenciaPage({Key? key}) : super(key: key);
  @override
  State<VigenciaPage> createState() => _VigenciaPageState();
}

class _VigenciaPageState extends State<VigenciaPage> {
  ServicioHttp service = ServicioHttp();
  String vigenciaSeleccionada = "0";
  List vigencias = List.empty();
  List cajas = List.empty();
  bool proceso = true;
   final oCcy = NumberFormat("#,##0.00", "en_US");
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Image.asset(
          "assets/background.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ), 
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity, 
              padding: EdgeInsets.only(top: 90),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Seleccione una vigencia",style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
                          value: vigenciaSeleccionada,
                          items: vigencias.isNotEmpty
                              ? vigencias
                                  .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value['codperiodo'].toString(),
                                    child: Text("Vigencia - "+value['periodo'].toString()),
                                  );
                                }).toList()
                              : [
                                  DropdownMenuItem(
                                    child: Text("Seleccione una vigencia"),
                                    value: "0",
                                  ),
                                ],
                          onChanged: (value) {
                            setState(() {
                              vigenciaSeleccionada = value!;
                              consultarDeclaracionesInfo(vigenciaSeleccionada);
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    !proceso ? 
                      cajas.isNotEmpty ? Container(
                        padding: EdgeInsets.only(bottom: 190),
                        color: Colors.transparent,
                        height: size.height - size.height*0.02,
                        child: ListView.builder(
                          itemCount: cajas.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return itemCard(cajas[index]);
                          }
                        )
                      ): Center()
                    : Container(
                        padding: EdgeInsets.only(top: 190),
                        child: Center(child: CircularProgressIndicator()),
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
    consultarVigencias();
  }
  consultarVigencias() async {
    setState(() {
      proceso = true;
    });
    var response = await service.vigencias();
    vigencias = List.empty();
    setState(() {
      vigencias = response["vigencias"];
      proceso = false;
      if(vigencias.isNotEmpty){
        vigenciaSeleccionada = vigencias[1]["codperiodo"];
        consultarDeclaracionesInfo(vigenciaSeleccionada);
      }
    });
  }
  consultarDeclaracionesInfo(String periodo) async {
    setState(() {
      proceso = true;
    });

    var response = await service.municipiosVijenciasCajas(periodo);
    cajas = List.empty();
    setState(() {
      cajas = response["periodos"];
      proceso = false;
    });
  }

  Widget itemCard(dynamic item){
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          BouncyPageRoute(widget: DetallePage(item["codmun"].toString(), item["periodo"].toString()))
        ); 
      },
      child: Container(
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
                color: Color.fromARGB(255, 255, 255, 255),
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
                  Text(item["nombremun"], style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Vigencia: "+item["periodo"].toString(), style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Declarado: \$ ${oCcy.format(item["total"]).toString().replaceAll(".00", "")}', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(41),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/MUN/"+item["codmun"]+".png"),
                ),
              ),
              width: 82,
              height: 82,
              margin:  EdgeInsets.symmetric(vertical: 16.0),
            )
          ],
        )
      ),
    ) ;
  }
}