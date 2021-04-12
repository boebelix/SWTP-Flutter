import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:swtp_app/services/poi_service.dart';
import 'package:swtp_app/widgets/poi_overview.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  PoiService poiService = PoiService();
  bool poiSelected = false;

  String title;
  String description;
  String category;
  Image image;

  void onPoiClicked(
      String title, String description, String category, Image image) {
    setState(() {
      this.title = title;
      this.description = description;
      this.category = category;
      this.image = image;
      poiSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            center: LatLng(49.260152, 7.360296),
            zoom: 10.0,
            maxZoom: 18,
            minZoom: 5,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://tile.openstreetmap.de/{z}/{x}/{y}.png",
              additionalOptions: {
                'id': 'mapbox.streets',
              },
            ),
            MarkerLayerOptions(
              markers: [
                ...(poiService.pois).map((poi) {
                  return Marker(
                    width: 80.0,
                    height: 80.0,
                    point:
                        LatLng(poi.position.latitude, poi.position.longitude),
                    builder: (ctx) => Container(
                      child: GestureDetector(
                        child: Icon(
                          Icons.location_on,
                          color: Theme.of(context).primaryColor,
                          size: 50,
                        ),
                        onTap: () {
                          onPoiClicked(poi.title, poi.description,
                              poi.category.name, poi.image);
                        },
                      ),
                    ),
                  );
                }).toList()
              ],
            ),
          ],
        ),
        poiSelected == true
            ? PoiOverview(title: title, description: description, image: image)
            : Container(),
      ],
    );
  }
}
