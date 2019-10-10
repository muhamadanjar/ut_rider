import 'package:flutter/material.dart';
import 'package:ut_order/models/auth.dart';
import 'package:ut_order/pages/dashboard_page.dart';
import 'package:ut_order/pages/login_page.dart';
import 'package:ut_order/pages/splash_page.dart';
import 'routes.dart';
import 'package:provider/provider.dart';
import 'provider_setup.dart';
import 'utils/constans.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return
      MultiProvider(
        providers: providers,
        child:Consumer<AuthBloc>(
          builder:(context,auth,_) => MaterialApp(
            title: 'Pemesanan Taxi',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Montserrat',
            ),
            home: auth.isAuth ? DashboardPage()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting ? SplashScreen(): LoginPage(),
                  ),

            onGenerateRoute: Router.generateRoute,

          ),
        )
      );
  }
}

