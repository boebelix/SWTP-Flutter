import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/providers/auth_endpoint_provider.dart';
import 'package:swtp_app/widgets/warning_dialog.dart';

class AuthEndpointVisualisation extends StatefulWidget {
  final String destinationRouteBySuccess;

  AuthEndpointVisualisation({@required this.destinationRouteBySuccess});

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
              return _loadingIndicator(context);
            }
            break;

          default:
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
        }
      },
    );
  }

  Widget _loadingIndicator(BuildContext context) {
    final sizeLoadingIndicator = MediaQuery.of(context).size.shortestSide * 0.7;
    return Center(
      child: SizedBox(
        height: sizeLoadingIndicator,
        width: sizeLoadingIndicator,
        child: CircularProgressIndicator(
          strokeWidth: 10,
        ),
      ),
    );
  }

  void _loginSuccessChangeScreen(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.popAndPushNamed(context, widget.destinationRouteBySuccess);
    });
  }
}
