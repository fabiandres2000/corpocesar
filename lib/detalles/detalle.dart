// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:corpo/detalles/detalle-vigencia-torta.dart';
import 'package:corpo/detalles/detalle-vigencia.dart';
import 'package:flutter/material.dart';


class DetallePage extends StatefulWidget {
  const DetallePage(this.municipio, this.periodoSeleccionado, {Key? key}) : super(key: key);
  final String municipio;
  final String periodoSeleccionado;
  @override
  _DetallePageState createState() => _DetallePageState();
}

class _DetallePageState extends State<DetallePage> with SingleTickerProviderStateMixin {
  
  late TabController controladorMenu;

  bool not = false;

  late Widget pagina;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  TabBarView(
        children: <Widget>[DetalleVigenciaPage(widget.municipio, widget.periodoSeleccionado), DetalleVigenciaTortaPage(widget.municipio, widget.periodoSeleccionado)],
        controller: controladorMenu,
      ),
      bottomNavigationBar:  Material(
        color: Color(0xff0C4E8B),
        child:  TabBar(
          tabs: <Tab>[
            Tab(
              icon: Icon(Icons.list, color: Colors.white)
            ),
            Tab(
              icon: Icon(Icons.pie_chart, color: Colors.white)
            ),
          ],
          labelColor: Colors.white,
          controller: controladorMenu,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controladorMenu = TabController(length: 2, vsync: this);
  }

}
