import 'package:flutter/material.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/models/failure.dart';

// ignore: non_constant_identifier_names
Widget PopUpWarningDialog({BuildContext context, Failure failure}) {
  BuildContext dialogContext;
  WidgetsBinding.instance.addPostFrameCallback(
    (_) {
      showDialog(
        context: context,
        //barrierDismissible: false,
        builder: (BuildContext context) {
          dialogContext = context;
          return Container(
            child: AlertDialog(
              title: Text(S.of(context).alert_dialog_title),
              content: Text(failure.message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: Text(S.of(context).alert_dialog_button_text),
                ),
              ],
            ),
          );
        },
      );
    },
  );

  return Container();
}
