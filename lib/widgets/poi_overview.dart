import 'package:flutter/material.dart';
import 'package:swtp_app/models/poi.dart';
import 'package:swtp_app/widgets/poi_detail_widget.dart';

class PoiOverview extends StatelessWidget {
  final Poi poi;

  PoiOverview({@required this.poi});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        width: double.infinity,
        height: 100,
        color: Colors.white,
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  color: Colors.amber,
                  child: poi.image != null
                      ? Image(
                          image: poi.image.image,
                        )
                      : Container(),
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        poi.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 32,
                        child: Text(
                          poi.description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        height: 22,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, PoiDetailWidget.routeName, arguments: poi);
                          },
                          child: Text('Details'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
