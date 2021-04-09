import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(49.260152, 7.360296),
        zoom: 13.0,
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
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(49.260152, 7.360296),
              builder: (ctx) => Container(
                child: GestureDetector(
                  child: Icon(
                    Icons.location_on,
                    color: Theme.of(context).primaryColor,
                    size: 50,
                  ),
                  onTap: () {
                    print('test}');
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
    ;
  }
}
