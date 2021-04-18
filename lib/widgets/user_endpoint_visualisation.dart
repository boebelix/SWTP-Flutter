import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/models/notifier_state.dart';
import 'package:swtp_app/providers/user_service_provider.dart';
import 'package:swtp_app/widgets/loading_indicator.dart';
import 'package:swtp_app/widgets/warning_dialog.dart';

class UserScreenVisualisation extends StatefulWidget {
  @override
  _UserScreenVisualisationState createState() => _UserScreenVisualisationState();
}

class _UserScreenVisualisationState extends State<UserScreenVisualisation> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserServiceProvider>(
      builder: (_, notifier, __) {
        switch (notifier.state) {
          case NotifierState.initial:
            return Container();
            break;
          case NotifierState.loading:
            return LoadingIndicator();
            break;
          default:
            return notifier.allUsersResponse.fold(
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
                return Container();
              },
            );
        }
      },
    );
  }
}

