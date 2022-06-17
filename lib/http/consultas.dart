import 'constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ServicioHttp {
  
  Future<dynamic> declaracionesMunicipio() async {
    dynamic respuesta;
    final link = Uri.parse(BaseUrl + "declaraciones-general-municipio");
    final response = await http.get(link);

    if (response.statusCode != 200) {
      respuesta.mensaje = "no existe esa URL";
      respuesta.success = 0;
    } else {
      var json = convert.jsonDecode(response.body);
      respuesta = json;
    }
    return respuesta;
  }

  Future<dynamic> declaracionesVigencia() async {
    dynamic respuesta;
    final link = Uri.parse(BaseUrl + "declaraciones-general-vigencia");
    final response = await http.get(link);

    if (response.statusCode != 200) {
      respuesta.mensaje = "no existe esa URL";
      respuesta.success = 0;
    } else {
      var json = convert.jsonDecode(response.body);
      respuesta = json;
    }
    return respuesta;
  }

  Future<dynamic> municipios() async {
    dynamic respuesta;
    final link = Uri.parse(BaseUrl + "municipios");
    final response = await http.get(link);

    if (response.statusCode != 200) {
      respuesta.mensaje = "no existe esa URL";
      respuesta.success = 0;
    } else {
      var json = convert.jsonDecode(response.body);
      respuesta = json;
    }
    return respuesta;
  }

  Future<dynamic> infoMunicipio(String idmun) async {
    dynamic respuesta;
    final link = Uri.parse(BaseUrl + "declaraciones-municipio-vigencia?mun="+"20"+idmun);
    final response = await http.get(link);

    if (response.statusCode != 200) {
      respuesta.mensaje = "no existe esa URL";
      respuesta.success = 0;
    } else {
      var json = convert.jsonDecode(response.body);
      respuesta = json;
    }
    return respuesta;
  }

  Future<dynamic> infoMunicipioPeriodo(String idmun, String periodo) async {
    dynamic respuesta;
    final link = Uri.parse(BaseUrl + "declaraciones-municipio-vigencia-periodo?mun=20"+idmun+"&per="+periodo);
    final response = await http.get(link);

    if (response.statusCode != 200) {
      respuesta.mensaje = "no existe esa URL";
      respuesta.success = 0;
    } else {
      var json = convert.jsonDecode(response.body);
      respuesta = json;
    }
    return respuesta;
  }

  Future<dynamic> totalVigencia(String idmun, String periodo) async {
    dynamic respuesta;
    final link = Uri.parse(BaseUrl + "total-vigencia?mun=20"+idmun+"&per="+periodo);
    final response = await http.get(link);

    if (response.statusCode != 200) {
      respuesta.mensaje = "no existe esa URL";
      respuesta.success = 0;
    } else {
      var json = convert.jsonDecode(response.body);
      respuesta = json;
    }
    return respuesta;
  }

  Future<dynamic> totalPorMesVigencia(String idmun, String periodo) async {
    dynamic respuesta;
    final link = Uri.parse(BaseUrl + "detalle-vigencia?mun=20"+idmun+"&per="+periodo);
    final response = await http.get(link);

    if (response.statusCode != 200) {
      respuesta.mensaje = "no existe esa URL";
      respuesta.success = 0;
    } else {
      var json = convert.jsonDecode(response.body);
      respuesta = json;
    }
    return respuesta;
  }

  Future<dynamic> vigencias() async {
    dynamic respuesta;
    final link = Uri.parse(BaseUrl + "vigencias");
    final response = await http.get(link);

    if (response.statusCode != 200) {
      respuesta.mensaje = "no existe esa URL";
      respuesta.success = 0;
    } else {
      var json = convert.jsonDecode(response.body);
      respuesta = json;
    }
    return respuesta;
  }

  Future<dynamic> municipiosVijenciasCajas(String periodo) async {
    dynamic respuesta;
    final link = Uri.parse(BaseUrl + "declaraciones-vigencia-vigencia?per="+periodo);
    final response = await http.get(link);

    if (response.statusCode != 200) {
      respuesta.mensaje = "no existe esa URL";
      respuesta.success = 0;
    } else {
      var json = convert.jsonDecode(response.body);
      respuesta = json;
    }
    return respuesta;
  }

  Future<dynamic> semaforo(String tipo, String f1, String f2, String periodo) async {
    dynamic respuesta;
    final link = Uri.parse(BaseUrl + "semaforo?tipo="+tipo+"&f1="+f1+"&f2="+f2+"&per="+periodo);
    final response = await http.get(link);

    if (response.statusCode != 200) {
      respuesta.mensaje = "no existe esa URL";
      respuesta.success = 0;
    } else {
      var json = convert.jsonDecode(response.body);
      respuesta = json;
    }
    return respuesta;
  }


}
