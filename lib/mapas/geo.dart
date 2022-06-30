import 'dart:async';
import 'dart:typed_data';
import 'package:corpo/componentes/bouncy.dart';
import 'package:corpo/consultas/consulta-por-municipio.dart';
import 'package:corpo/http/consultas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class MapaPage extends StatefulWidget {
  MapaPage({Key? key }): super(key: key);
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  String currentAddress = 'My Address';
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = new Set();
  late Uint8List  customIcon;
  double alto = 0;

  List municipios = List.empty();

  ServicioHttp service = ServicioHttp();

  final oCcy = NumberFormat("#,##0.00", "en_US");
  String declaradoSeleccionado = "0.00";
  String municipioSeleccionado = "";
  String municipioSeleccionadoCodigo = "";

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(9.762017898962904, -73.466518845942422),
    zoom: 8,
  );

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _setIcon();
    cerrarmodal();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new BlurryModalProgressHUD(
      inAsyncCall: loading,
      blurEffectIntensity: 4,
      progressIndicator: Image.asset(
        'assets/app_logo.gif',
        width: 500,
        height: 800,
      ),
      dismissible: false,
      opacity: 0.6,
      color: Colors.white,
      child: Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Color(0xff0C4E8B),
        automaticallyImplyLeading: false,
        title: Center(child: Text("VALOR DECLARADO POR MUNICIPIO", style: TextStyle(fontSize: 18),)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body:Stack(
        children: [
          Container(
            width: double.infinity,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            bottom: alto,
            child: Container(
              height: 200,
              width: size.width,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child:  Column(
                children : <Widget>[
                  Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.close),
                          tooltip: 'Cerrar ventana',
                          onPressed: () {
                            setState(() {
                             cerrarmodal();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("DECLARACIÓN DETALLE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black))
                    ],
                  ),
                  SizedBox(height: 7),
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Slidable(
                      key: const ValueKey(0),
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: verDetalles,
                            backgroundColor: Color(0xff0C4E8B),
                            foregroundColor: Colors.white,
                            icon: Icons.details_sharp,
                            label: 'Ver detalles',
                          ),
                        ],
                      ),
                      child: Container(
                        child: ListTile(
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10),
                              Text("Municipio: ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              Text(municipioSeleccionado, style: TextStyle(fontSize: 14))
                            ],
                          ),
                          subtitle: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Valor declarado: ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              Text(oCcy.format(double.parse(declaradoSeleccionado)), style: TextStyle(fontSize: 14))
                            ],
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/swipe.gif',
                                width: 50,
                                height: 40,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ]
              ),
            )
          ),
        ]
      ),
    ));
  }


  _setIcon() async {
    customIcon =  await getBytesFromAsset('assets/position.png', 90);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }


  _determinePosition() async {
    var response1 =  await service.ubic();
    setState(() {
      municipios = response1["declaraciones"];
      Future.delayed(const Duration(milliseconds: 5000), _addMarkers);
    });
  }

  cerrarmodal() {
    setState(() {
      alto = -1 * 200;
    });
  }



  void _addMarkers() async {
    for (var item in municipios) {
      var icon = await getBytesFromAsset('assets/MUN-ROUNDED/'+item["municipio_codigo"]+'.png', 70);
      markers.add(Marker(
        markerId: MarkerId(item["municipio_codigo"].toString()),
        position: LatLng(double.parse(item["lat"]), double.parse(item["lon"])),
        icon: BitmapDescriptor.fromBytes(icon),
        onTap: () {
          configCaja(item); 
        }
      ));
    }

    setState(() {
      loading = false;
    });
  }

  configCaja(var item) {
    setState(() {
      alto = 0;
      declaradoSeleccionado = item["total"].toString();
      municipioSeleccionado = item['municipio_nombre'];
      municipioSeleccionadoCodigo = item["municipio_codigo"];
    });
  }

  void verDetalles(BuildContext context) {
    Navigator.push(
      context,
      BouncyPageRoute(widget: MunicipioPage(municipioSeleccionadoCodigo))
    ); 
  }

}