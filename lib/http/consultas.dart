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


}
