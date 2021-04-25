import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:swtp_app/endpoints/poi_endpoint.dart';
import 'package:swtp_app/l10n/failure_translation.dart';
import 'package:swtp_app/models/category.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/poi.dart';
import 'package:swtp_app/models/position.dart';
import 'package:swtp_app/models/user.dart';
import 'package:swtp_app/providers/poi_service_provider.dart';

class MockPoiEndpoint extends Mock implements PoiEndpoint {}

void main() {
  MockPoiEndpoint mockPoiEndpoint;
  PoiServiceProvider poiServiceProvider;
  List<Poi> pois = [];

  poiServiceProvider = PoiServiceProvider();


  setUp(() {
    mockPoiEndpoint = MockPoiEndpoint();
    pois.add(Poi(
        author: User(
            userId: 1,
            userName: "test",
            firstName: "test",
            lastName: "test",
            email: "test123@email.com",
            city: "Muster",
            zip: "00000",
            street: "Muster",
            streetNr: "1"),
        poiId: 1,
        createDate: DateTime.now().toString(),
        position: Position(longitude: 1.0, latitude: 1.0),
        category: Category(name: "T", categoryId: 1),
        title: "TestTitle",
        description: "description"),);
  });

  group("get Poi", () {
    test("get Poi for User", () async {
      //arrange
      when(mockPoiEndpoint.getPoiForUser(any)).thenAnswer((_) async {
        return pois;
      });
      List<int> userIds=[];
      userIds.add(1);
      //act
      await poiServiceProvider.getAllVisiblePois(userIds);
      //assert
      verify(mockPoiEndpoint.getPoiForUser(any));
    });

    test("get Poi for User failed", () async {
      //arrange
      when(mockPoiEndpoint.getPoiForUser(any)).thenThrow(Failure(FailureTranslation.text('noConnection')));
      List<int> userIds=[];
      userIds.add(1);
      //act
      await poiServiceProvider.getAllVisiblePois(userIds);
      print(poiServiceProvider.pois);
      //assert
      expect(poiServiceProvider.pois, pois);
    });
  });
}
