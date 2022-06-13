import 'package:flutter/material.dart';
import 'package:corpo/http/consultas.dart';

class VigenciaPage extends StatefulWidget {
  const VigenciaPage({Key? key}) : super(key: key);
  @override
  State<VigenciaPage> createState() => _VigenciaPageState();
}

class _VigenciaPageState extends State<VigenciaPage> {
  ServicioHttp servie = ServicioHttp();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container()
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
    
  }
}