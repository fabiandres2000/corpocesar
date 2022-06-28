// ignore_for_file: prefer_const_constructors
import 'package:corpo/consultas/consulta-general.dart';
import 'package:corpo/consultas/consulta-por-municipio.dart';
import 'package:corpo/consultas/consulta-por-vigencia.dart';
import 'package:corpo/mapas/geo.dart';
import 'package:corpo/semaforo/semaforo.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    GeneralPage(),
    MunicipioPage("0"),
    VigenciaPage(),
    SemaforoPage(),
    MapaPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar : true,
      appBar: AppBar(
         elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          padding: EdgeInsets.only(left: 30),
          child: Text(""),
        ),
      ),
      body: _children[_currentIndex],
      drawer: Drawer(  
        child: ListView(   
          padding: EdgeInsets.zero,  
          children: <Widget>[  
            UserAccountsDrawerHeader (  
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient:  const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment(0.0, 1.0),
                  colors:  <Color>[
                    Color.fromARGB(255, 2, 88, 80),
                    Color.fromRGBO(3, 129, 117, 1),
                  ],
                  tileMode: TileMode.repeated, 
                )
              ),
              accountName: Text("Abhishek Mishra"),  
              accountEmail: Text("abhishekm977@gmail.com"),  
              currentAccountPicture: CircleAvatar(  
                backgroundColor: Colors.orange,  
                child: Text(  
                  "A",  
                  style: TextStyle(fontSize: 40.0),  
                ),  
              ),  
            ),  
            ListTile(  
              leading: Icon(Icons.home), 
              title: Text("Informe General"),  
              onTap: () {  
                Navigator.pop(context);
                onTabTapped(0);
              },  
            ),  
            ListTile(  
              leading: Icon(Icons.location_city_rounded), 
              title: Text("Informe por municipio"),  
              onTap: () {  
                Navigator.pop(context);
                onTabTapped(1);
              },  
            ),  
            ListTile(  
              leading: Icon(Icons.calendar_month), 
              title: Text("Informe por vigencia"),  
              onTap: () {  
                Navigator.pop(context);
                onTabTapped(2); 
              },  
            ),  
            ListTile(  
              leading: Icon(Icons.traffic), 
              title: Text("Semaforo"),  
              onTap: () {  
                Navigator.pop(context);
                onTabTapped(3); 
              },  
            ),
            ListTile(  
              leading: Icon(Icons.map), 
              title: Text("Ver en mapa"),  
              onTap: () {  
                Navigator.pop(context);
                onTabTapped(4); 
              },  
            ),  
          ],  
        ),  
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

}