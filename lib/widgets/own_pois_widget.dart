import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/models/notifier_state.dart';
import 'package:swtp_app/models/poi.dart';
import 'package:swtp_app/providers/poi_service_provider.dart';
import 'package:swtp_app/services/auth_service.dart';
import 'package:swtp_app/widgets/loading_indicator.dart';
import 'package:swtp_app/widgets/poi_detail_widget.dart';
import 'package:swtp_app/widgets/warning_dialog.dart';

class OwnPOIWidget extends StatefulWidget {
  OwnPOIWidget();

  @override
  State<StatefulWidget> createState() => _OwnPOIWidgetState();
}

class _OwnPOIWidgetState extends State<OwnPOIWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PoiServiceProvider>(
      builder: (_, notifier, __) {
        switch (notifier.state) {
          case NotifierState.initial:
            return Container();
            break;
          case NotifierState.loading:
            return LoadingIndicator();
            break;
          default:
            return notifier.poiResponse.fold(
              (failure) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  notifier.resetState();
                });
                return PopUpWarningDialog(
                  context: context,
                  failure: failure,
                );
              },
              (r) {
                List<Poi> ownPois=notifier.pois.where((elem)=>elem.author==AuthService().user).toList();
                if(ownPois.isEmpty){
                  return Center(
                    child: Text(Language.of(context).noPoiYet),
                  );
                }
                return ListView.builder(
                    padding: EdgeInsets.all(5),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: ownPois.length,
                    itemBuilder: (context, index) {
                      return _buildCardForPoi(ownPois.elementAt(index));
                    });
              },
            );
        }
      },
    );
  }

  Widget _buildCardForPoi(Poi poi)
  {
    return Card(
      child:Container(
      width: double.infinity,
      height: 100,
      color: Colors.white,
      child: Card(
        key: UniqueKey(),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        margin: EdgeInsets.zero,
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                color: Colors.amber,
                child: poi.image != null
                    ? Image(
                  image: poi.image.image,
                )
                    : Container(),
              ),
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      poi.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 32,
                      child: Text(
                        poi.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    //Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //children: [
                        Container(
                          alignment: Alignment.bottomRight,
                          height: 22,
                          child: ElevatedButton(
                            onPressed: () {
                              _getPoiComments(context,poi);
                              Navigator.pushNamed(context, PoiDetailWidget.routeName, arguments: poi.poiId);
                            },
                            child: Text('Details'),
                          ),
                        ),
                        //Container(
                          //alignment: Alignment.bottomRight,
                          //height: 22,
                          //child: ElevatedButton(
                            //onPressed: () {
                              //Falls irgendwann vorhanden, hier Methode zum Löschen eines POI aufrufen
                            //},
                            //child: Text(Language.of(context).delete),
                          //),
                        //),
                      //],
                    //),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
  void _getPoiComments(BuildContext context, Poi poi) async {
    poi.comments = await Provider.of<PoiServiceProvider>(context, listen: false).getCommentsForPoi(poi.poiId);
  }
}
