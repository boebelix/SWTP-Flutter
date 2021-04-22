import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/providers/poi_service_provider.dart';

class CreateComment extends StatefulWidget {
  final int poiId;

  CreateComment({this.poiId});

  @override
  _CreateCommentState createState() => _CreateCommentState(poiId: poiId);
}

class _CreateCommentState extends State<CreateComment> {
  final int poiId;

  _CreateCommentState({this.poiId});

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController commentController = TextEditingController();

  void _createPoiComment() async {
    if (_formKey.currentState.validate()) {
      await Provider.of<PoiServiceProvider>(context, listen: false).createCommentForPoi(poiId, commentController.text);
      commentController.clear();
    }
  }

  String _validatorComment(value) {
    if (value == null || value.isEmpty) {
      return Language.of(context).warning_comment_NN;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Flexible(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: Language.of(context).comment,
                ),
                controller: commentController,
                validator: _validatorComment,
              ),
            ),
            IconButton(
                icon: Icon(
                  Icons.send,
                  size: 30,
                ),
                onPressed: _createPoiComment)
          ],
        ),
      ),
    );
  }
}
