class Position {
  double latitude;
  double longitude;

  Position({this.latitude, this.longitude});

  factory Position.fromJSON(Map<String, dynamic> json) =>
      Position(latitude: json['latitude'], longitude: json['longitude']);

  @override
  String toString() {
    return 'Position{latitude: $latitude, longitude: $longitude}';
  }
}
