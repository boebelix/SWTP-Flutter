import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/providers/auth_endpoint_provider.dart';
import 'package:swtp_app/providers/categories_service_provider.dart';
import 'package:swtp_app/providers/group_service_provider.dart';
import 'package:swtp_app/providers/poi_service_provider.dart';
import 'package:swtp_app/providers/user_service_provider.dart';
import 'package:swtp_app/screens/invite_user_screen.dart';
import 'package:swtp_app/screens/login_screen.dart';
import 'package:swtp_app/screens/profile_screen.dart';
import 'package:swtp_app/screens/tabs_screen.dart';
import 'package:swtp_app/services/auth_service.dart';
import 'package:swtp_app/widgets/add_poi_form.dart';
import 'package:swtp_app/widgets/poi_detail_widget.dart';
import 'package:swtp_app/widgets/register.dart';

void main() {
  init().then((_) => runApp(MyApp()));
}

//void, da Route durch Endpoint visualisation gesetzt wird, die in einem Stack über LogIn Screen liegen
Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool hasToken = await AuthEndpointProvider.storage.containsKey(key: 'token');
  bool hasUserId = await AuthEndpointProvider.storage.containsKey(key: 'userId');

  if (hasToken && hasUserId) {
    AuthService().token = await AuthEndpointProvider.storage.read(key: 'token');
    String userIdString = await AuthEndpointProvider.storage.read(key: 'userId');
    int userId = int.parse(userIdString);
    await AuthEndpointProvider().checkIfAlreadyLoggedInAndLoadUser(userId);

    AuthEndpointProvider().reloadUserResponse.fold((failure) {
    }, (success) {
      GroupServiceProvider()
          .loadAllGroups()
          .then((value) => UserServiceProvider().getAllUsers(GroupServiceProvider().ownGroup))
          .then((value) => AuthService().loadUsersAndPoiData());

    });
  }
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
        ChangeNotifierProvider(
          create: (_) => UserServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoriesServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => GroupServiceProvider(),
        )
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
          buttonColor: Color.fromRGBO(255, 186, 53, 1.0),
        ),
        //keine initial Route, da Route durch Endpoint visualisation lassen gesetzt wird, die in Stack über LogIn Screen liegen
        routes: {
          '/': (ctx) => LoginScreen(),
          TabScreen.routeName: (ctx) => TabScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          Register.routeName: (ctx) => Register(),
          PoiDetailWidget.routeName: (ctx) => PoiDetailWidget(),
          AddPoiForm.routeName: (ctx) => AddPoiForm(),
          InviteUserScreen.routeName: (ctx) => InviteUserScreen(),
          ProfileScreen.routeName: (ctx) => ProfileScreen(),
        },
      ),
    );
  }
}
