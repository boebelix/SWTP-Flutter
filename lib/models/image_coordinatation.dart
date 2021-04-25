import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';

enum StatusImageSourceFrom { camera, map }

class ImageCoordinatation {
  File file;
  LatLng location;
  StatusImageSourceFrom status;

  ImageCoordinatation({this.file, @required this.location, @required this.status});
}
