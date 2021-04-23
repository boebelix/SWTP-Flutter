import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/models/notifier_state.dart';
import 'package:swtp_app/models/poi.dart';
import 'package:swtp_app/models/image_coordinatation.dart';
import 'package:swtp_app/providers/poi_service_provider.dart';
import 'package:swtp_app/widgets/add_poi_form.dart';
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
  LocationData currentPosition;

  ImageCoordinatation _imageCoordinatation;
  final _imagePicker = ImagePicker();
  Location _location = Location();

  Widget detectionHandler() {
    switch (_detection) {
      case clickDetection.poiClicked:
        return PoiOverview(poi: _poi);
        break;
      case clickDetection.newPoiClicked:
        return AddPoiButton(_setPoiAtThisPosition);
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
                    _cameraButton(context),
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

  Future<void> getImageFromCamera() async {
    var _serviceEnabled = await _location.serviceEnabled();

    // Check, ob GPS aktiviert
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    // Check, ob genügent Rechte für GPS, sonst erfrage noch einmal
    var _permissionGranted = await _location.hasPermission();

    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return null;
      }
    } else {
      currentPosition = await _location.getLocation();
    }

    final pickedImage = await _imagePicker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedImage != null) {
        _imageCoordinatation = ImageCoordinatation(
          file: File(pickedImage.path),
          location: LatLng(currentPosition.latitude, currentPosition.longitude),
        );
      } else {
        _imageCoordinatation = null;
      }
    });
  }

  Positioned _cameraButton(BuildContext context) {
    const double size = 60;
    return Positioned(
        top: 0,
        right: 0,
        child: Container(
          margin: EdgeInsets.all(10),
          height: size,
          child: SizedBox.fromSize(
            size: Size(size, size), // button width and height
            child: ClipOval(
              child: Material(
                color: Theme.of(context).primaryColor, // button color
                child: InkWell(
                  splashColor: Color.fromRGBO(248, 177, 1, 1),
                  // splash color
                  onTap: () async {
                    await getImageFromCamera().then(
                      (value) => Navigator.pushNamed(
                        context,
                        AddPoiForm.routeName,
                        arguments: _imageCoordinatation,
                      ),
                    );
                  },
                  // button pressed
                  child: Icon(
                    Icons.photo_camera_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ));
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
