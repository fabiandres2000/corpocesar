// ignore_for_file: prefer_const_constructors
import 'package:corpo/consulta-general.dart';
import 'package:corpo/consulta-por-municipio.dart';
import 'package:corpo/consulta-por-vigencia.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    GeneralPage(),
    MunicipioPage(),
    VigenciaPage(),
  ];

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(3, 129, 117, 1),
        title: Container(
          padding: EdgeInsets.only(left: 30),
          child: Text(widget.title),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          )
      ),
      body: _children[_currentIndex],
      drawer: Drawer(  
        child: ListView(   
          padding: EdgeInsets.zero,  
          children: <Widget>[  
            UserAccountsDrawerHeader(  
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
              leading: Icon(Icons.home), title: Text("Informe General"),  
              onTap: () {  
                Navigator.pop(context);
                onTabTapped(0);
              },  
            ),  
            ListTile(  
              leading: Icon(Icons.settings), title: Text("Informe por municipio"),  
              onTap: () {  
                Navigator.pop(context);
                onTabTapped(1);
              },  
            ),  
            ListTile(  
              leading: Icon(Icons.contacts), title: Text("Informe por vigencia"),  
              onTap: () {  
                Navigator.pop(context);
                onTabTapped(2); 
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