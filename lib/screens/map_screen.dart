import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:swtp_app/services/poi_service.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  PoiService poiService = PoiService();
  LatLng setPoiAtThisPosition;

  @override
  Widget build(BuildContext context) {
    Marker setPoiHere = _poiAtPositionLatLng(context, setPoiAtThisPosition);

    return FlutterMap(
      options: MapOptions(
          center: LatLng(49.260152, 7.360296),
          zoom: 10.0,
          maxZoom: 18,
          minZoom: 5,
          onTap: _setTabbedPostion),
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
              return _poiAtPositionLatLng(
                context,
                LatLng(poi.position.latitude, poi.position.longitude),
              );
            }).toList(),
            setPoiHere,
          ],
        ),
      ],
    );
  }

  Marker _poiAtPositionLatLng(BuildContext context, LatLng latLng) {
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
}
