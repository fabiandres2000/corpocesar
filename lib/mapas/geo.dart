import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'dart:ui' as ui;
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';

// ignore: must_be_immutable
class MapaPage extends StatefulWidget {
 
  MapaPage({Key? key }): super(key: key);

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  
  String currentAddress = 'My Address';
  late Location location;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = new Set();
  late Uint8List  customIcon;
  double alto = 0;

  final geo.Geolocator geolocator = geo.Geolocator();
  
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(9.762017898962904, -73.466518845942422),
    zoom: 8,
  );

  bool loading = true;

  @override
  void initState() {
    super.initState();
    location = new Location();
    _determinePosition();
    _setIcon();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new BlurryModalProgressHUD(
      inAsyncCall: loading,
      blurEffectIntensity: 4,
      progressIndicator: Image.asset(
        'assets/app_logo.gif',
        width: 200,
        height: 100,
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
        title: Center(child: Text("DECLARACION POR MUNICIPIO", style: TextStyle(fontSize: 20),)),
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
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    var _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        return;
      }
    }

    setState(() {
      loading = false;
    });
  }

  cerrarmodal() {
    setState(() {
      alto = -1 * 200;
    });
  }


 /*
  void _addMarkers() {
   
    for (var item in listaPorMunicipio) {
      markers.add(Marker(
        //add first marker
        markerId: MarkerId(item["id_proyect"].toString()),
        position: LatLng(double.parse(item["lat_ubic"]), double.parse(item["long_ubi"])),
        icon: BitmapDescriptor.fromBytes(customIcon),
        onTap: () {
         
        }
      ));
    }
 
  }

  mostrarcaja(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return GeolocalizacionFiltro();
    }).whenComplete(() {

    });
  }

  */

}