import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/providers/auth_endpoint_provider.dart';
import 'package:swtp_app/models/notifier_state.dart';
import 'package:swtp_app/widgets/loading_indicator.dart';
import 'package:swtp_app/widgets/warning_dialog.dart';

class AuthEndpointVisualisation extends StatefulWidget {
  @override
  _AuthEndpointVisualisationState createState() =>
      _AuthEndpointVisualisationState();
}

class _AuthEndpointVisualisationState extends State<AuthEndpointVisualisation> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthEndpointProvider>(
      builder: (_, notifier, __) {
        switch (notifier.state) {
          case NotifierState.initial:
            {
              return Container();
            }
            break;

          case NotifierState.loading:
            {
              return LoadingIndicator();
            }
            break;

          default:
            {
              if(notifier.authResponse!=null)
              {
                return notifier.authResponse.fold(
                  //Fehlerfall
                  (failure) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      notifier.resetState();
                    });
                    return PopUpWarningDialog(
                      context: context,
                      failure: failure,
                    );
                  },
                  // Alles in Ordnung
                  (userService) {
                    return Container();
                  },
                );
              }
              else
                return notifier.reloadUserResponse.fold(
                  //Fehlerfall
                      (failure) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      notifier.resetState();
                    });
                    return PopUpWarningDialog(
                      context: context,
                      failure: failure,
                    );
                  },
                  // Alles in Ordnung
                      (userService) {
                    return Container();
                  },
                );
            }
        }
      },
    );
  }
}
