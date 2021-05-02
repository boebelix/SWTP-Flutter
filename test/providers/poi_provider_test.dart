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

  PoiEndpoint poiEndpoint;
  PoiServiceProvider poiServiceProvider;

  List<Poi> pois=[];

  setUp(() {
    if(pois.isNotEmpty){
      pois.clear();
    }

    pois=[Poi.fromJSON(jsonDecode(fixture('test_poi.json')))];
    poiEndpoint = MockPoiEndpoint();
    poiServiceProvider = PoiServiceProvider();
    poiServiceProvider.poiEndpoint = poiEndpoint;
    pois[0].image = Image.file(File('response.jpeg'));
    pois[0].comments = [Comment.fromJson(jsonDecode(fixture('test_comment.json')))];
  });

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
      expect(poiServiceProvider.pois.toString(), pois.toString());

      poiServiceProvider.resetState();
    });

    test("get all Poi Comments for a specific Poi", () async {
      poiServiceProvider.pois=pois;

      when(poiEndpoint.getCommentsForPoi(any)).thenAnswer((_) async {
        return [Comment.fromJson(jsonDecode(fixture('test_comment.json')))];
      });
      await poiServiceProvider.getCommentsForPoi(1);

      verify(poiEndpoint.getCommentsForPoi(any)).called(1);
      expect(poiServiceProvider.pois.first.comments.toString(), pois[0].comments.toString());

      poiServiceProvider.resetState();
    });
  });

  group("create and delete comments", () {
    test("create Comment", () async {
      poiServiceProvider.pois=pois;

      when(poiEndpoint.createCommentForPoi(any, any)).thenAnswer((_) async {
        return Comment.fromJson(jsonDecode(fixture('test_comment.json')));
      });
      Comment comment = Comment.fromJson(jsonDecode((fixture('test_comment.json'))));
      await poiServiceProvider.createCommentForPoi(1, comment.comment);

      verify(poiEndpoint.createCommentForPoi(any, any)).called(1);
      expect(poiServiceProvider.pois.first.comments.length, 2);
      expect(poiServiceProvider.pois.first.comments.last.toString(), comment.toString());

      poiServiceProvider.resetState();
    });

    test("delete Comment", () async {
      poiServiceProvider.pois=pois;

      when(poiEndpoint.deleteComment(any)).thenAnswer((_) async => null);

      await poiServiceProvider.deleteComment(1, 1);

      verify(poiEndpoint.deleteComment(1)).called(1);
      expect(poiServiceProvider.pois.first.comments.isEmpty, true);

      poiServiceProvider.resetState();
    });
  });

  test("create Poi", () async {
    Poi poi = Poi.fromJSON(jsonDecode(fixture('test_poi.json')));
    File file = File('App/test/fixtures/response.jpeg');
    poi.image = Image.file(File('response.jpeg'));
    when(poiEndpoint.createPoi(any, any, any, any)).thenAnswer((_) async {
      return Poi.fromJSON(jsonDecode(fixture('test_poi.json')));
    });
    when(poiEndpoint.uploadImage(any, any)).thenAnswer((_) async => null);

    await poiServiceProvider.createPoi(
        title: poi.title,
        description: poi.description,
        categoryId: poi.category.categoryId,
        position: poi.position,
        image: file);

    verify(poiEndpoint.createPoi(any, any, any, any)).called(1);
    expect(poiServiceProvider.pois.length, 1);
    expect(poiServiceProvider.pois.last.toString(), poi.toString());
    expect(poiServiceProvider.pois.last.image != null, true);
  });
}
