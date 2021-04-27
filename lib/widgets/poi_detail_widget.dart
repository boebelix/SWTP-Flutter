import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/models/notifier_state.dart';
import 'package:swtp_app/models/poi.dart';
import 'package:swtp_app/providers/poi_service_provider.dart';
import 'package:swtp_app/services/auth_service.dart';
import 'package:swtp_app/widgets/warning_dialog.dart';
import 'package:swtp_app/models/comment.dart';
import 'package:swtp_app/widgets/create_comment.dart';
import 'loading_indicator.dart';

class PoiDetailWidget extends StatefulWidget {
  static const routeName = '/poiDetailWidget';

  @override
  _PoiDetailWidgetState createState() => _PoiDetailWidgetState();
}

class _PoiDetailWidgetState extends State<PoiDetailWidget> {
  PoiServiceProvider _poiServiceProvider;

  String _formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return DateFormat.yMMMd().add_Hm().format(dateTime);
  }

  void _deleteComment(int poiId, int commentId) async {
    await _poiServiceProvider.deleteComment(poiId, commentId);
  }

  @override
  Widget build(BuildContext context) {
    final int poiId = ModalRoute.of(context).settings.arguments as int;

    final Poi poi =
        Provider.of<PoiServiceProvider>(context, listen: false).pois.where((element) => element.poiId == poiId).first;

    _poiServiceProvider = Provider.of<PoiServiceProvider>(context, listen: false);
    var deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(poi.title),
      ),
      body: Column(
        children: [
          poi.image == null
              ? Container()
              : Container(
                  constraints: BoxConstraints(
                    maxHeight: deviceSize.height * 0.42,
                    maxWidth: deviceSize.width,
                  ),
                  child: Image(
                    image: poi.image.image,
                  ),
                ),
          Wrap(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: 250,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                      child: Text(
                        poi.description,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            Language.of(context).author + ": " + poi.author.firstName + " " + poi.author.lastName,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            "${_formatDate(poi.createDate)}",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          //Platzhalter für späteren Einbau der Kommentarfunktion
          Flexible(
            child: Consumer<PoiServiceProvider>(
              builder: (_, notifier, __) {
                switch (notifier.state) {
                  case NotifierState.initial:
                    return Container();
                    break;
                  case NotifierState.loading:
                    return LoadingIndicator();
                    break;
                  default:
                    return notifier.poiCommentResponse.fold(
                      (failure) {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) {
                            notifier.resetState();
                          },
                        );

                        return PopUpWarningDialog(
                          context: context,
                          failure: failure,
                        );
                      },
                      (_) {
                        List<Comment> comments = Provider.of<PoiServiceProvider>(context, listen: false)
                            .pois
                            .where((element) => element.poiId == poi.poiId)
                            .first
                            .comments;

                        int itemCount = comments.length;

                        return ListView.builder(
                          padding: EdgeInsets.all(5),
                          shrinkWrap: false,
                          scrollDirection: Axis.vertical,
                          itemCount: itemCount,
                          itemBuilder: (context, index) => _buildCommentCard(comments.elementAt(index), poi),
                        );
                      },
                    );
                }
              },
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomLeft,
            child: CreateComment(
              poiId: poi.poiId,
            ),
          ),
        ],
      ),
    );
  }

  Card _buildCommentCard(Comment comment, Poi poi) {
    return Card(
      key: UniqueKey(),
      elevation: 0,
      child: Container(
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Icon(
                  Icons.account_circle_outlined,
                  size: 40,
                ),
              ),
              SizedBox(
                width: 18,
              ),
              Flexible(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  color: Colors.black38,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(comment.author.firstName + " " + comment.author.lastName),
                            Text('${_formatDate(comment.createDate)}')
                          ],
                        ),
                        Text(
                          comment.comment,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: comment.author.userId == AuthService().user.userId
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _deleteComment(poi.poiId, comment.commentId);
                        },
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
