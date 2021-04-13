import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/providers/poi_endpoint_provider.dart';
import 'package:swtp_app/widgets/warning_dialog.dart';

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
    return Consumer<PoiEndpointProvider>(
      builder: (_, notifier, __) {
        switch (notifier.state) {
          case NotifierState.initial:
            return Container();
            break;
          case NotifierState.loading:
            return _loadingIndicator(context);
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
              (poiList) {
                _loginSuccessChangeScreen(context);
                return Container();
              },
            );
        }
      },
    );
  }

  Widget _loadingIndicator(BuildContext context) {
    final sizeLoadingIndicator = MediaQuery.of(context).size.shortestSide * 0.3;
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
