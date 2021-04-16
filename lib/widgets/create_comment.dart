import 'package:flutter/material.dart';
import 'package:swtp_app/generated/l10n.dart';

class CreateComment extends StatefulWidget {
  @override
  _CreateCommentState createState() => _CreateCommentState();
}

class _CreateCommentState extends State<CreateComment> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController commentController = TextEditingController();

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
            Icon(Icons.send,size: 30,),
          ],
        ),
      ),
    );
  }

  String _validatorComment(value) {
    if (value == null || value.isEmpty) {
      return Language.of(context).warning_comment_NN;
    }
    return null;
  }
}
