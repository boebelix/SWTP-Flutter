import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/locale.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/models/poi.dart';
import 'package:swtp_app/services/auth_service.dart';

class PoiDetailWidget extends StatefulWidget {
  static const routeName = '/poiDatailWidget';

  @override
  _PoiDetailWidgetState createState() => _PoiDetailWidgetState();
}

class _PoiDetailWidgetState extends State<PoiDetailWidget> {
  @override
  Widget build(BuildContext context) {
    final Poi poi = ModalRoute.of(context).settings.arguments as Poi;

    final DateTime dateTime = DateTime.parse(poi.createDate);
    final String formattedDate = DateFormat.yMMMd().add_Hm().format(dateTime);

    return Scaffold(
      appBar: AppBar(
        title: Text(poi.title),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 2,
            child: Image(
              image: poi.image.image,
            ),
          ),
          Flexible(
            flex: 1,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8,right: 8),
                  child: Text(
                    poi.description,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        Language.of(context).author + ": " + poi.author.firstName + " " + poi.author.lastName,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        "$formattedDate",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          //Platzhalter für späteren Einbau der Kommentarfunktion
          Flexible(
            flex: 2,
            child: Container(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
