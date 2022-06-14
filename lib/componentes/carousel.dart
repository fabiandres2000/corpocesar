// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Carousel extends StatelessWidget {
 
  Carousel({required Key key, required List lista}) : super(key: key);
  List
  Size size = Size(10,20);
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return CarouselSlider(
      options: CarouselOptions(
        enableInfiniteScroll: true,
        reverse: false,
        viewportFraction: 0.86,
        height: 240,
      ),
      items: itemCarousel(context),
    );
  }

  List<Widget> itemCarousel(BuildContext context) {
    List<Widget> widgets = [];
    if ( != null) {
      for (var item in barberias) {
        widgets.add(Padding(
            padding: const EdgeInsets.only(right: 15.0, bottom: 20.0, top: 10),
            child: InkWell(
              onTap: () {
                
              },
              child: Container(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 10),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.white54,
                          offset: Offset(4.0, 4.0),
                          blurRadius: 10)
                    ]),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        
                      ],
                    ),
                    
                  ],
                ),
              ),
            )));
      }
    }
    return widgets;
  }
}