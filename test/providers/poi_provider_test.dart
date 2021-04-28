import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:swtp_app/endpoints/poi_endpoint.dart';
import 'package:swtp_app/models/comment.dart';
import 'package:swtp_app/models/poi.dart';
import 'package:swtp_app/providers/poi_service_provider.dart';

import '../fixtures/fixture_reader.dart';

class MockPoiEndpoint extends Mock implements PoiEndpoint {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  PoiEndpoint poiEndpoint = MockPoiEndpoint();
  PoiServiceProvider poiServiceProvider = PoiServiceProvider();
  poiServiceProvider.poiEndpoint = poiEndpoint;

  List<Poi> pois = [Poi.fromJSON(jsonDecode(fixture('test_poi.json')))];
  pois[0].image = Image.file(File('response.jpeg'));

  group("get all Poi information", () {
    test("get all relevant Pois", () async {
      when(poiEndpoint.getPoiForUser(any)).thenAnswer((_) async {
        return [Poi.fromJSON(jsonDecode(fixture('test_poi.json')))];
      });
      when(poiEndpoint.getPoiImage(any)).thenAnswer((_) async {
        return Image.file(File('response.jpeg'));
      });

      await poiServiceProvider.getAllVisiblePois([1]);

      verify(poiEndpoint.getPoiForUser(any)).called(1);
      //TODO: Equatable einbauen da sonst kein Vergleich der Inhalte möglich => equatable einbauen
      expect(poiServiceProvider.pois[0].poiId, pois[0].poiId);
    });

    test("get all Poi Comments for a specific Poi", () async {
      when(poiEndpoint.getCommentsForPoi(any)).thenAnswer((_) async {
        return [Comment.fromJson(jsonDecode(fixture('test_comment.json')))];
      });

      await poiServiceProvider.getCommentsForPoi(1);

      verify(poiEndpoint.getCommentsForPoi(any));
    });
  });
}
