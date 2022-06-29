// ignore_for_file: prefer_const_constructors;, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:corpo/http/consultas.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SemaforoPage extends StatefulWidget {
  const SemaforoPage({Key? key}) : super(key: key);
  @override
  State<SemaforoPage> createState() => _SemaforoPageState();
}

class _SemaforoPageState extends State<SemaforoPage> {
 
  ServicioHttp service = ServicioHttp();
  List tipoBusqueda = ["0", "Vigencia", "Meses","Años"];
  List tipoMeses = [0,1,2,3,4,5,6,7,8,9,10,11,12];
  List tipoAnio = [0,1,2,3,4];
  List tipoVigencia = List.empty();
  List dataCombo = List.empty();
  String tipoBusquedaSeleccionada = "0";

  String comboBusqueda = "0";

  DateTime now =  DateTime.now();

  List listaNoDeclarado = List.empty(); 

  bool proceso = false;

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
          appBar: PreferredSize(
          preferredSize: Size.fromHeight(10.0), // here the desired height
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          )
        ),
          body: SingleChildScrollView(
            child: Container( 
              width: double.infinity, 
              padding: EdgeInsets.only(top: 0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Declaraciones pendientes", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
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
                          value: tipoBusquedaSeleccionada,
                          items: tipoBusqueda
                            .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value.toString(),
                              child: value != "0" ? Text(value): Text("Seleccione un tipo de busqueda"),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              tipoBusquedaSeleccionada = value!;
                              if(tipoBusquedaSeleccionada == "Meses"){
                                comboBusqueda = "0";
                                dataCombo = tipoMeses;
                              }else{
                                if(tipoBusquedaSeleccionada == "Años"){
                                  comboBusqueda = "0";
                                  dataCombo = tipoAnio;
                                }else{
                                  comboBusqueda = "0";
                                  dataCombo = tipoVigencia;
                                }
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height:15),
                    tipoBusquedaSeleccionada != "0" ? Padding(
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
                          value: comboBusqueda,
                          items: dataCombo
                            .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: tipoBusquedaSeleccionada == "Vigencia" ? value.toString() : value.toString(),
                              child: tipoBusquedaSeleccionada == "Vigencia" ? value == 0 ? Text("Seleccione....."): Text("Vigencia - "+value.toString()) : (value == 0 ? Text("Seleccione....."): value == 1 ?  Text(value.toString()+ (tipoBusquedaSeleccionada == "Meses" ? " mes" : " año")): Text(value.toString()+ (tipoBusquedaSeleccionada == "Meses" ? " meses" : " años"))),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              comboBusqueda = value!;
                              if(comboBusqueda != "0"){
                                consultarData();
                              }
                            });
                          },
                        ),
                      ),
                    ): Center(),
                    SizedBox(height: size.height * 0.05),
                    !proceso ? listaNoDeclarado.isNotEmpty ? Container(
                      padding: EdgeInsets.only(bottom: 210),
                      color: Colors.transparent,
                      height: size.height - size.height * 0.1,
                      child: ListView.builder(
                        itemCount: listaNoDeclarado.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return itemCard(listaNoDeclarado[index]);
                        }
                      )
                    ): Container(
                      padding: EdgeInsets.only(top: 130),
                      child: Center(
                        child: Column(
                          children: [
                            Image(
                              image: AssetImage("assets/fail.png"),
                              height: 150.0,
                              width: 150.0,
                            ),
                            SizedBox(height: 10),
                            Text("No hay resultados", style: TextStyle(color: Colors.grey))
                          ],
                        )
                      ),
                    ) : Container(
                      padding: EdgeInsets.only(top: 130),
                      child: Center(child: CircularProgressIndicator())
                    ),
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
    tipoVigencia = List.empty();
    setState(() {
      tipoVigencia = [0,now.year-9,now.year-8,now.year-7,now.year-6,now.year-5,now.year-4,now.year-3,now.year-2,now.year-1,now.year];
    });
  }

  consultarData() async {
    setState(() {
      proceso = true;
    });
    String date2 = DateTime(now.year, now.month, now.day).toString().split(" ")[0];
    String vigenciaSel = "";
    String date1;
    String tipo = "";
    switch (tipoBusquedaSeleccionada) {
      case "Meses":
        date1 = DateTime(now.year, now.month - int.parse(comboBusqueda), now.day).toString().split(" ")[0];
        tipo = "1";
      break;
      case "Años":
        date1 = DateTime(now.year - int.parse(comboBusqueda), now.month, now.day).toString().split(" ")[0];
        tipo = "2";
      break;
      default:
        vigenciaSel = comboBusqueda.toString();
        date1 = DateTime(now.year, now.month, now.day).toString();  
        tipo = "3";
    }

    var response = await service.semaforo(tipo, date1, date2, vigenciaSel);

    setState(() {
      listaNoDeclarado = response["municipios"];
      proceso = false;
    });
    
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
                Text(item["descripcion"], style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text("Ultima Declaración realizada el: "+item["detalle"][0]["fecha"], style: TextStyle(color: Color.fromARGB(255, 175, 3, 3), fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text('Declarado: \$ ${oCcy.format(double.parse(item["detalle"][0]["total"])).replaceAll(".00", "")}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black))
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
    );
  }
}