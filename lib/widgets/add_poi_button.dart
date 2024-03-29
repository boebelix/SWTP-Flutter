import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/models/image_coordinatation.dart';
import 'package:swtp_app/providers/categories_service_provider.dart';
import 'package:swtp_app/widgets/add_poi_form.dart';
import 'package:latlong/latlong.dart';

class AddPoiButton extends StatelessWidget {
  final LatLng currentPosition;

  AddPoiButton(this.currentPosition);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.08,
        color: Colors.white,
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 4,
              primary: Theme.of(context).buttonColor,
            ),
            onPressed: () {
              _getAllCategoriesAsyn(context);
              Navigator.pushNamed(context, AddPoiForm.routeName,
                  arguments: ImageCoordinatation(
                    file: null,
                    location: currentPosition,
                    status: StatusImageSourceFrom.map,
                  ));
            },
            child: Text(
              Language.of(context).addNewPoi,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Future _getAllCategoriesAsyn(BuildContext context) async {
    await Provider.of<CategoriesServiceProvider>(context, listen: false).getAllCategories();
  }
}
