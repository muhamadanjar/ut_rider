enum AlertAction {
  cancel,
  discard,
  disagree,
  agree,
}

const String apiURL = "http://192.168.43.110/api";
const bool devMode = false;
const double textScaleFactor = 1.0;
const google_android_api = 'AIzaSyAKl4qWeBABIDPoxo_CHvWuIfgkKoEzS7c';
const google_web_api = 'AIzaSyAyGT-CSg1nb0YBLihgn8vk9zfbbkk-f1c';


class RoutePaths {
  static const String Login = 'login';
  static const String Help = 'help';
  static const String Home = 'home-page';
  static const String Settings = 'settings';
  static const String Payment = 'payment';
  static const String OrderComplete = 'order-complete-page';
  static const String MyTrip = 'my-trip';
}