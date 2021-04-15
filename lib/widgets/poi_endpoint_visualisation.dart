import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/providers/poi_service_provider.dart';
import 'package:swtp_app/widgets/loading_indicator.dart';
import 'package:swtp_app/widgets/warning_dialog.dart';
import 'package:swtp_app/models/notifier_state.dart';

class PoiEndpointVisualisation extends StatefulWidget {
  final String destinationRouteBySuccess;

  PoiEndpointVisualisation({this.destinationRouteBySuccess});

  @override
  _PoiEndpointVisualisationState createState() =>
      _PoiEndpointVisualisationState();
}

class _PoiEndpointVisualisationState extends State<PoiEndpointVisualisation> {
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
                _loginSuccessChangeScreen(context);
                return Container();
              },
            );
        }
      },
    );
  }

  void _loginSuccessChangeScreen(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.popAndPushNamed(context, widget.destinationRouteBySuccess);
    });
  }
}
