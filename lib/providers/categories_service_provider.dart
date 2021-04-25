import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:swtp_app/endpoints/poi_endpoint.dart';
import 'package:swtp_app/models/category.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/notifier_state.dart';

class CategoriesServiceProvider extends ChangeNotifier {
  static final CategoriesServiceProvider _instance = CategoriesServiceProvider._internal();

  factory CategoriesServiceProvider() => _instance;

  CategoriesServiceProvider._internal();

  NotifierState _state = NotifierState.initial;

  PoiEndpoint _poiEndpoint = PoiEndpoint();
  List<Category> categories = [];
  Either<Failure, List<Category>> categoriesResponse;

  NotifierState get state => _state;

  void setState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  void resetState() {
    categories.clear();
    setState(NotifierState.initial);

    notifyListeners();
  }

  _setCategoriesResponse(Either<Failure, List<Category>> categoriesResponse) {
    if (categoriesResponse.isRight()) {
      categories.addAll(categoriesResponse.getOrElse(() => null));
    }

    this.categoriesResponse = categoriesResponse;
  }

  Future<void> getAllCategories() async {
    setState(NotifierState.loading);
    categories.clear();

    await Task(() => _poiEndpoint.getAllCategories())
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) => _setCategoriesResponse(value));

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
