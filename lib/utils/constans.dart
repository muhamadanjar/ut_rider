import 'package:flutter/widgets.dart';

enum AlertAction {
  cancel,
  discard,
  disagree,
  agree,
}
enum pemesananLokasi{
  from_address,
  to_address
}

const bool devMode = false;
const String apiURL = devMode == true ? "http://192.168.100.45/api":"http://utama-trans.com/new/api";
const double textScaleFactor = 1.0;
const google_android_api = 'AIzaSyAKl4qWeBABIDPoxo_CHvWuIfgkKoEzS7c';
const google_web_api = 'AIzaSyAyGT-CSg1nb0YBLihgn8vk9zfbbkk-f1c';


class RoutePaths {
  static const String Index = '/';
  static const String Login = 'login';
  static const String Register = 'register';
  static const String Help = 'help';
  static const String Dashboard = 'dashboard';
  static const String Home = 'home-page';
  static const String Settings = 'settings';
  static const String Payment = 'payment';
  static const String OrderComplete = 'order-complete-page';
  static const String MyTrip = 'my-trip';
  static const String TopUp = 'topup';
  static const String Promo = 'promo';
  static const String Rental = 'rental';
  static const String Forgot = 'forgot';
  static const String Legal = 'legal';
  static const String Profile = 'profile';
  static const String EditProfile = 'edit_profile';
  static const String Notifications = 'notifications';
  static const String ChangePassword = 'change_password';
  static const String ChangeProfile = 'change_profile';


}

class SizeConfig{
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockWidth;
  static double blockHeight;

  void init(BuildContext context) { 
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockWidth = screenWidth / 100;
    blockHeight = screenHeight / 100;
    
  }
}

