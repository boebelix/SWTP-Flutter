import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';

enum StatusImageSourceFrom { camera, map }

class ImageCoordinatation {
  File file;

  @required
  LatLng location;

  @required
  StatusImageSourceFrom status;

  ImageCoordinatation({this.file, this.location, this.status});
}
