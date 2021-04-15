import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/providers/auth_endpoint_provider.dart';
import 'package:swtp_app/providers/poi_service_provider.dart';
import 'package:swtp_app/screens/login_screen.dart';
import 'package:swtp_app/screens/tabs_screen.dart';
import 'package:swtp_app/widgets/register.dart';
import 'package:swtp_app/widgets/poi_detail_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthEndpointProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PoiServiceProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'SWTP',
        localizationsDelegates: [
          Language.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: Language.delegate.supportedLocales,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.amber,
          canvasColor: Color.fromRGBO(255, 255, 255, 1.0),
        ),
        routes: {
          '/': (ctx) => LoginScreen(),
          TabScreen.routeName: (ctx) => TabScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          Register.routeName: (ctx) => Register(),
          PoiDetailWidget.routeName: (ctx) => PoiDetailWidget(),
        },
      ),
    );
  }
}
