import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:swtp_app/endpoints/poi_endpoint.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/poi.dart';
import 'package:swtp_app/models/notifier_state.dart';
import 'package:swtp_app/models/position.dart';
import 'package:swtp_app/models/comment.dart';

class PoiServiceProvider extends ChangeNotifier {
  static final PoiServiceProvider _instance = PoiServiceProvider._internal();

  factory PoiServiceProvider() => _instance;

  PoiServiceProvider._internal();

  NotifierState _state = NotifierState.initial;

  List<Poi> pois = [];

  Either<Failure, List<Poi>> poiResponse;
  Either<Failure, Image> poiImageResponse;
  Either<Failure, List<Comment>> poiCommentResponse;
  Either<Failure, Comment> poiCreateCommentResponse;
  Either<Failure, Poi> poiCreatePoiResponse;

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

    this.poiImageResponse = poiImageResponse;
  }

  _setCreateImageForPoi(File image, int poiId) {
    if (poiImageResponse.isRight()) {
      var poiAtId = pois.where((element) => element.poiId == poiId).first;
      poiAtId.image = Image.file(image);
    }
  }

  _setPoiComments(Either<Failure, List<Comment>> poiCommentResponse, int poiId) {
    if (poiCommentResponse.isRight()) {
      var poiAtId = pois.where((element) => element.poiId == poiId).first;

      poiAtId.comments.addAll(poiCommentResponse.getOrElse(null));
    }

    this.poiCommentResponse = poiCommentResponse;
  }

  _addPoiComment(Either<Failure, Comment> poiCreateCommentResponse, int poiId) {
    if (poiCreateCommentResponse.isRight()) {
      var poiAtId = pois.where((element) => element.poiId == poiId).first;

      poiAtId.comments.add(poiCreateCommentResponse.getOrElse(null));
    }

    this.poiCreateCommentResponse = poiCreateCommentResponse;
  }

  _setNewPoi(Either<Failure, Poi> poiCreatePoiResponse) {
    if (poiCreatePoiResponse.isRight()) {
      pois.add(poiCreatePoiResponse.getOrElse(null));
    }

    this.poiCreatePoiResponse = poiCreatePoiResponse;
  }

  Future<void> getAllVisiblePois(List<int> userIds) async {
    setState(NotifierState.loading);

    for (int i in userIds) {
      await Task(() => PoiEndpoint().getPoiForUser(i))
          .attempt()
          .mapLeftToFailure()
          .run()
          .then((value) => _setPoiResponse(value));
    }

    for (Poi i in pois) {
      await Task(() => PoiEndpoint().getPoiImage(i.poiId))
          .attempt()
          .mapLeftToFailure()
          .run()
          .then((value) => _setPoiImage(value, i.poiId));
    }

    setState(NotifierState.loaded);
  }

  Future<List<Comment>> getCommentsForPoi(int poiId) async {
    setState(NotifierState.loading);

    for (Poi poi in pois) {
      poi.comments.clear();
    }

    await Task(() => PoiEndpoint().getCommentsForPoi(poiId))
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) => _setPoiComments(value, poiId));

    setState(NotifierState.loaded);

    return pois.where((element) => element.poiId == poiId).first.comments;
  }

  Future<void> createCommentForPoi(int poiId, String comment) async {
    setState(NotifierState.loading);

    await Task(() => PoiEndpoint().createCommentForPoi(poiId, comment))
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) => _addPoiComment(value, poiId));

    setState(NotifierState.loaded);
  }

  Future<void> createPoi({String title, String description, int categoryId, Position position, File image}) async {
    setState(NotifierState.loading);

    await Task(() => PoiEndpoint().createPoi(categoryId, title, description, position))
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) => _setNewPoi(value));

    if (poiCreatePoiResponse.isRight() && image != null) {
      Poi poi = poiCreatePoiResponse.getOrElse(() => null);

      await Task(() => PoiEndpoint().uploadImage(image, poi))
          .attempt()
          .mapLeftToFailure()
          .run()
          .then((value) => _setCreateImageForPoi(image, poi.poiId));
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
