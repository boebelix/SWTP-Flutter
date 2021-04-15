import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/models/notifier_state.dart';
import 'package:swtp_app/models/poi.dart';
import 'package:swtp_app/providers/poi_service_provider.dart';
import 'package:swtp_app/widgets/loading_indicator.dart';
import 'package:swtp_app/widgets/poi_overview.dart';
import 'package:swtp_app/widgets/warning_dialog.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool poiSelected = false;

  String _title;
  String _description;
  String _category;
  Image _image;
  LatLng _setPoiAtThisPosition;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    Marker _setPoiHere = _createPoiAtPositionLatLng(context, _setPoiAtThisPosition);

    return Consumer<PoiServiceProvider>(
      builder: (_, notifier, __) {
        switch (notifier.state) {
          case NotifierState.initial:
            return Container();
            break;
          case NotifierState.loading:
            return LoadingIndicator();
            break;
          default:
            return notifier.poiResponse.fold(
              (failure) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) {
                    notifier.resetState();
                  },
                );

                return PopUpWarningDialog(
                  context: context,
                  failure: failure,
                );
              },
              (_) {
                return Stack(children: [
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
                          ...(Provider.of<PoiServiceProvider>(context,listen: false).pois).map((poi) {
                            return _poiAtPositionLatLng(context, poi);
                          }).toList(),
                          _setPoiHere
                        ],
                      ),
                    ],
                  ),
                  poiSelected == true
                      ? PoiOverview(title: _title, description: _description, image: _image)
                      : Container(),
                ]);
              },
            );
        }
      },
    );
  }

  Marker _poiAtPositionLatLng(BuildContext context, Poi poi) {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(poi.position.latitude, poi.position.longitude),
      builder: (ctx) => Container(
        child: GestureDetector(
          child: Icon(
            Icons.location_on,
            color: Theme.of(context).primaryColor,
            size: 50,
          ),
          onTap: () {
            _onPoiClicked(
                title: poi.title, description: poi.description, category: poi.category.name, image: poi.image);
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
      _setPoiAtThisPosition = latLng;
    });
  }

  void _onPoiClicked({String title, String description, String category, Image image}) {
    setState(() {
      this._title = title;
      this._description = description;
      this._category = category;
      this._image = image;
      poiSelected = true;
    });
  }
}
