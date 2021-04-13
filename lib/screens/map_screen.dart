import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:swtp_app/models/poi.dart';
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
  LatLng setPoiAtThisPosition;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    Marker setPoiHere = _createPoiAtPositionLatLng(context, setPoiAtThisPosition);

    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            center: LatLng(49.260152, 7.360296),
            zoom: 10.0,
            maxZoom: 18,
            minZoom: 5,
            onTap: _setTabbedPostion,
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
                  return _poiAtPositionLatLng(context, poi);
                }).toList(),
                setPoiHere
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

  Marker _poiAtPositionLatLng(BuildContext context, Poi poi) {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(poi.position.latitude,poi.position.longitude),
      builder: (ctx) => Container(
        child: GestureDetector(
          child: Icon(
            Icons.location_on,
            color: Theme.of(context).primaryColor,
            size: 50,
          ),
          onTap: () {
            onPoiClicked(
                poi.title, poi.description, poi.category.name, poi.image);
          },
        ),
      ),
    );
  }

  Marker _createPoiAtPositionLatLng(BuildContext context, LatLng latLng) {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: latLng,
      builder: (ctx) => Container(
        child: GestureDetector(
          child: Icon(
            Icons.location_on,
            color: Theme.of(context).primaryColor,
            size: 50,
          ),
          onTap: () {},
        ),
      ),
    );
  }

  void _setTabbedPostion(LatLng latLng) {
    setState(() {
      setPoiAtThisPosition = latLng;
    });
  }

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
}
