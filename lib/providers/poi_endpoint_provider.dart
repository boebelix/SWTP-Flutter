import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:swtp_app/endpoints/poi_endpoint.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/poi.dart';
import 'package:swtp_app/services/poi_service.dart';

enum NotifierState { initial, loading, loaded }

class PoiEndpointProvider extends ChangeNotifier {
  static final PoiEndpointProvider _instance = PoiEndpointProvider._internal();

  factory PoiEndpointProvider() => _instance;

  PoiEndpointProvider._internal();

  NotifierState _state = NotifierState.initial;

  PoiEndpoint _poiEndpoint = PoiEndpoint();

  PoiService poiService = PoiService();

  Either<Failure, List<Poi>> poiResponse;

  NotifierState get state => _state;

  void setState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  void resetState() {
    PoiService().pois.clear();
    setState(NotifierState.initial);

    notifyListeners();
  }

  _setPoiResponse(Either<Failure, List<Poi>> poiResponse) {
    if (poiResponse.isRight()) {
      poiService.pois.addAll(poiResponse.getOrElse(null));
    }

    this.poiResponse = poiResponse;
  }

  _setPoiImage(Either<Failure, Image> poiImageResponse, int poiId) {
    if (poiImageResponse.isRight()) {
      poiService.pois.where((element) => element.poiId == poiId).first.image =
          poiImageResponse.getOrElse(null);
    }
  }

  Future<void> getAllVisiblePois(List<int> userIds) async {
    setState(NotifierState.loading);

    for (int i in userIds) {
      await Task(() => _poiEndpoint.getPoiForUser(i))
          .attempt()
          .mapLeftToFailure()
          .run()
          .then((value) => _setPoiResponse(value));
    }
    for (Poi i in poiService.pois) {
      await Task(() => _poiEndpoint.getPoiImage(i.poiId))
          .attempt()
          .mapLeftToFailure()
          .run()
          .then((value) => _setPoiImage(value, i.poiId));
    }

    setState(NotifierState.loaded);
  }
}

extension TaskX<T extends Either<Object, U>, U> on Task<T> {
  Task<Either<Failure, U>> mapLeftToFailure() {
    return this.map(
      (either) => either.leftMap((obj) {
        try {
          return obj as Failure;
        } catch (e) {
          throw obj;
        }
      }),
    );
  }
}
