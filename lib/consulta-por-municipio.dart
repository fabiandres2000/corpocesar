// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:corpo/http/consultas.dart';

class MunicipioPage extends StatefulWidget {
  const MunicipioPage({Key? key}) : super(key: key);
  @override
  State<MunicipioPage> createState() => _MunicipioPageState();
}

class _MunicipioPageState extends State<MunicipioPage> {
  ServicioHttp service = ServicioHttp();
  List municipios = List.empty();
  String combosecre = "0";

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
              padding:  EdgeInsets.symmetric(horizontal: 5),
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
                    });
                  },
                ),
              ),
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
}