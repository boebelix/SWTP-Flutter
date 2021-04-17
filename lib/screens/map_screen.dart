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
import 'package:swtp_app/widgets/add_poi_button.dart';
import 'package:swtp_app/providers/categories_service_provider.dart';

enum clickDetection { nothingClicked, poiClicked, newPoiClicked }

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  clickDetection _detection = clickDetection.nothingClicked;

  Poi _poi;

  LatLng _setPoiAtThisPosition;

  Widget detectionHandler() {
    switch (_detection) {
      case clickDetection.poiClicked:
        return PoiOverview(poi: _poi);
        break;
      case clickDetection.newPoiClicked:
        return AddPoiButton();
        break;
      default:
        return Container();
    }
  }

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
                return Stack(
                  children: [
                    _showMap(context, _setPoiHere),

                    detectionHandler(),

                    // Beim klicken auf neuen Poi erstellen werden die Kategorien geladen
                    _showLoadingIndicatorWhileGetCategories(),
                  ],
                );
              },
            );
        }
      },
    );
  }

  FlutterMap _showMap(BuildContext context, Marker _setPoiHere) {
    return FlutterMap(
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
            ...(Provider.of<PoiServiceProvider>(context, listen: false).pois).map((poi) {
              return _poiAtPositionLatLng(context, poi);
            }).toList(),
            _detection == clickDetection.poiClicked ? Marker() : _setPoiHere
          ],
        ),
      ],
    );
  }

  Consumer<CategoriesServiceProvider> _showLoadingIndicatorWhileGetCategories() {
    return Consumer<CategoriesServiceProvider>(
      builder: (_, notifier, __) {
        if (notifier.state == NotifierState.loading) {
          return LoadingIndicator();
        }
        return Container();
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
            _onPoiClicked(poi: poi);
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
            color: Theme.of(context).buttonColor,
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
      _detection = clickDetection.newPoiClicked;
    });
  }

  void _onPoiClicked({@required Poi poi}) {
    setState(() {
      this._poi = poi;
      _detection = clickDetection.poiClicked;
    });
  }
}
