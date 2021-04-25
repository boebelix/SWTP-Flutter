import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/models/poi.dart';
import 'package:swtp_app/providers/poi_service_provider.dart';
import 'package:swtp_app/widgets/poi_detail_widget.dart';

class PoiOverview extends StatelessWidget {
  final Poi poi;

  PoiOverview({@required this.poi});

  void _getPoiComments(BuildContext context) async {
    poi.comments = await Provider.of<PoiServiceProvider>(context, listen: false).getCommentsForPoi(poi.poiId);
  }

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
                fit: FlexFit.tight,
                child: Container(
                  color: Colors.amber,
                  child: poi.image != null
                      ? Image(
                          image: poi.image.image,
                          fit: BoxFit.cover,
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
                            _getPoiComments(context);
                            Navigator.pushNamed(context, PoiDetailWidget.routeName, arguments: poi.poiId);
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
