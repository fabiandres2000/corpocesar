// ignore_for_file: prefer_const_constructors

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:corpo/http/consultas.dart';
import 'package:flutter/material.dart';


class SimpleBarChartPage extends StatefulWidget {
  const SimpleBarChartPage(this.tipo, {Key? key, required this.animate}) : super(key: key);

  final String tipo;
  final bool animate;

  @override
  State<SimpleBarChartPage> createState() => _SimpleBarChartPageState();
}

class _SimpleBarChartPageState extends State<SimpleBarChartPage> {

  List<charts.Series<dynamic, String>> seriesList = List.empty();
  List porMunicipio = List.empty();
  List porVigencia = List.empty();
  ServicioHttp service = ServicioHttp();

  bool proceso = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          height: 250,
          child: !proceso ? charts.BarChart(
            seriesList,
            animate: widget.animate,
            barRendererDecorator: charts.BarLabelDecorator<String>(
              insideLabelStyleSpec: charts.TextStyleSpec(
                fontSize: 6,
                color: charts.MaterialPalette.white
              ),
              outsideLabelStyleSpec: charts.TextStyleSpec(
                fontSize: 6,
                color: charts.MaterialPalette.black
              ),
            ),
            primaryMeasureAxis:  charts.NumericAxisSpec(
              renderSpec:  charts.SmallTickRendererSpec(
                labelStyle:  charts.TextStyleSpec(
                  fontSize: 8,
                  color: charts.MaterialPalette.black,
                ),
                lineStyle:  charts.LineStyleSpec(
                  color: charts.MaterialPalette.black
                ),
              ),
              tickProviderSpec: charts.BasicNumericTickProviderSpec(desiredTickCount: 10)
            ),
            domainAxis:  charts.OrdinalAxisSpec(
              renderSpec:  charts.SmallTickRendererSpec(
                labelStyle:  charts.TextStyleSpec(
                  fontSize: 6,
                  color: charts.MaterialPalette.black
                ),
                lineStyle:  charts.LineStyleSpec(
                  color: charts.MaterialPalette.black
                )
                )
              ),
          ): Center(child: CircularProgressIndicator()),
        ),
      ],
    ) ;
  }

  _createData() async {
    await consultarData();

    List<DataSample> data = [];
    if(widget.tipo == "general1"){
      for (var i = 0; i < 5; i++) {
        var item = porMunicipio[i];
        var dataitem = DataSample(i, item["municipio_nombre"], item["total"]/1000000);
        data.add(dataitem);
      }
    }else{
      if(widget.tipo == "general1.1"){
        var index = 0;
        for (var i = porMunicipio.length-5; i < porMunicipio.length; i++) {
          var item = porMunicipio[i];
          var dataitem = DataSample(index ,item["municipio_nombre"], item["total"]/1000000);
          data.add(dataitem);
          index++;
        }
      }else{
        var index = 0;
        for (var i = porVigencia.length-5; i < porVigencia.length; i++) {
          var item = porVigencia[i];
          var dataitem = DataSample(index, item["periodo"], item["total"]/1000000);
          data.add(dataitem);
          index++;
        }
      } 
    }
   

    setState(() {
      seriesList = [
        charts.Series<DataSample, String>(
          id: 'Sales',
          colorFn: (DataSample data, _) {
          switch (data.index) {
            case 0:
            {
              return charts.ColorUtil.fromDartColor(Color(0xff109618));
            }
            case 1:
            {
              return charts.ColorUtil.fromDartColor(Color(0xff94DD8B));
            }
            case 2:
            {
              return charts.ColorUtil.fromDartColor(Color(0xff0BB68C));
            }
            case 3:
            {
              return charts.ColorUtil.fromDartColor(Color(0xff0B81E3));
            }
            case 4:
            {
              return charts.ColorUtil.fromDartColor(Color(0xff0C4E8B));
            }
            default:
            {
              return charts.ColorUtil.fromDartColor(Color(0xff990099));
            }
          }
        },
          domainFn: (DataSample data, _) => data.item,
          measureFn: (DataSample data, _) => data.total,
          data: data,
          labelAccessorFn: (DataSample data, _) =>'\$${data.total.toStringAsFixed(2)}'
        )
      ];
      proceso = false;
    });
    
  }

  @override
  void initState() {
    super.initState();
    _createData();
  }

  consultarData() async {
    var response1 = await service.declaracionesMunicipio();
    var response2 = await service.declaracionesVigencia();
    setState(() {
      porMunicipio = response1["declaraciones"];
      porVigencia = response2["declaraciones"];
    });
  }
}

class DataSample {
  final int index;
  final String item;
  final double total;

  DataSample(this.index, this.item, this.total);
}