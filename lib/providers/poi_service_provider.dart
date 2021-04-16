import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:swtp_app/endpoints/poi_endpoint.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/poi.dart';
import 'package:swtp_app/models/notifier_state.dart';
import 'package:swtp_app/services/log_service.dart';
import 'package:swtp_app/models/comment.dart';

class PoiServiceProvider extends ChangeNotifier {
  static final PoiServiceProvider _instance = PoiServiceProvider._internal();

  factory PoiServiceProvider() => _instance;

  PoiServiceProvider._internal();

  NotifierState _state = NotifierState.initial;

  PoiEndpoint _poiEndpoint = PoiEndpoint();

  List<Poi> pois = [];

  LogService logService = LogService();

  Either<Failure, List<Poi>> poiResponse;

  NotifierState get state => _state;

  void setState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  void resetState() {
    pois.clear();
    setState(NotifierState.initial);

    notifyListeners();
  }

  _setPoiResponse(Either<Failure, List<Poi>> poiResponse) {
    if (poiResponse.isRight()) {
      pois.addAll(poiResponse.getOrElse(() => null));
    }

    this.poiResponse = poiResponse;
  }

  _setPoiImage(Either<Failure, Image> poiImageResponse, int poiId) {
    if (poiImageResponse.isRight()) {
      var poiAtId = pois.where((element) => element.poiId == poiId).first;

      poiAtId.image = poiImageResponse.getOrElse(null);
    }
  }

  _setPoiComments(Either<Failure, List<Comment>> poiCommentResponse, int poiId) {
    if(poiCommentResponse.isRight()){
      var poiAtId = pois.where((element) => element.poiId==poiId).first;

      poiAtId.comments=poiCommentResponse.getOrElse(null);
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

    for (Poi i in pois) {
      await Task(() => _poiEndpoint.getPoiImage(i.poiId))
          .attempt()
          .mapLeftToFailure()
          .run()
          .then((value) => _setPoiImage(value, i.poiId));
    }

    setState(NotifierState.loaded);
  }

  Future<List<Comment>> getCommentsForPoi(int poiId) async {
    setState(NotifierState.loading);

    await Task(() => _poiEndpoint.getCommentsForPoi(poiId))
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) => _setPoiComments(value, poiId));

    setState(NotifierState.loaded);

    return pois.where((element) => element.poiId==poiId).first.comments;
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
