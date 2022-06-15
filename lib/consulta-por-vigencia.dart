// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:corpo/http/consultas.dart';

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
          body: Center(
            child: Container(
              padding: EdgeInsets.only(top: size.height * 0.105),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                                  child:
                                      Text("Vigencia - "+value['periodo'].toString()),
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
                ]
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
}