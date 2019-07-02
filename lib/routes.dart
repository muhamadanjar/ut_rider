import 'package:flutter/material.dart';
import 'package:ut_order/pages/topup_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/settings_page.dart';
import 'pages/payment_page.dart';
import 'pages/order_complete.dart';
import 'pages/your_trip_page.dart';
import 'pages/help_page.dart';
import 'pages/rental_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/register_page.dart';
import 'pages/notfound.dart';
import 'pages/promo_page.dart';
import 'pages/profil_page.dart';
import 'pages/notification_page.dart';
import 'utils/constans.dart';
final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    SettingsPage.tag:(context) => SettingsPage(),
    PaymentPage.tag:(context) => PaymentPage(),
    '/search':(context) => CustomSearchScaffold(),

};

class Router {
    static Route<dynamic> generateRoute(RouteSettings settings) {
        switch (settings.name) {
            case RoutePaths.Dashboard:
                return MaterialPageRoute(builder: (_) => DashboardPage());
            case RoutePaths.Profile:
                return MaterialPageRoute(builder: (_) => ProfilPage());
            case RoutePaths.Home:
                return MaterialPageRoute(builder: (_) => HomePage());
            case RoutePaths.Login:
                return MaterialPageRoute(builder: (_) => LoginPage());
            case RoutePaths.Register:
                return MaterialPageRoute(builder: (_) => RegisterPage());
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
            case RoutePaths.Rental:
                return MaterialPageRoute(builder: (_) => RentalPage());
            case RoutePaths.TopUp:
                return MaterialPageRoute(builder: (_) => TopupPage());
            case RoutePaths.Promo:
                return MaterialPageRoute(builder: (_) => PromoPage());
            case RoutePaths.Notifications:
                return MaterialPageRoute(builder: (_) => NotificationPage());
            default:
                return MaterialPageRoute(builder: (_) => NotFoundPage());
        }
    }
}