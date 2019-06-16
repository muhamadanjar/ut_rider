import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/settings_page.dart';
import 'pages/payment_page.dart';
import 'pages/order_complete.dart';
import 'pages/your_trip_page.dart';
import 'pages/help_page.dart';

import 'utils/constans.dart';
final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    SettingsPage.tag :(context) => SettingsPage(),
    '/payment':(BuildContext context) => new PaymentPage(),
    '/search':(context) => CustomSearchScaffold(),

};

class Router {
    static Route<dynamic> generateRoute(RouteSettings settings) {
        switch (settings.name) {
            case RoutePaths.Home:
                return MaterialPageRoute(builder: (_) => HomePage());
            case RoutePaths.Login:
                return MaterialPageRoute(builder: (_) => LoginPage());
            case RoutePaths.OrderComplete:
                return MaterialPageRoute(builder: (_) => OrderComplete());
            case RoutePaths.Settings:
                return MaterialPageRoute(builder: (_) => SettingsPage());
            case RoutePaths.Payment:
                return MaterialPageRoute(builder: (_) => PaymentPage());
            case RoutePaths.MyTrip:
                return MaterialPageRoute(builder: (_) => YourTripPage());
            case RoutePaths.Help:
                return MaterialPageRoute(builder: (_) => HelpPage());
            default:
                return MaterialPageRoute(
                    builder: (_) => Scaffold(
                        body: Center(
                            child: Text('No route defined for ${settings.name}'),
                        ),
                    ));
        }
    }
}