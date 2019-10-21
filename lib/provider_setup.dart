import 'package:provider/provider.dart';
import 'package:ut_order/data/order_view.dart';
import 'package:ut_order/utils/network_util.dart';
import 'package:ut_order/utils/prefs.dart';

import 'data/app_bloc.dart';
import 'data/place_bloc.dart';
import 'models/auth.dart';
import 'models/user.dart';
import 'utils/authentication.dart';
import 'utils/connectivity.dart';
import 'utils/promoService.dart' as ps;
import 'enum/connection_status.dart';
import 'models/order.dart';
import 'models/promo.dart';
import 'utils/order.service.dart';
List<SingleChildCloneableWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders,
];

List<SingleChildCloneableWidget> independentServices = [
  Provider.value(value: NetworkUtil()),
  ChangeNotifierProvider.value(
    value: AuthBloc(),
  ),
];

List<SingleChildCloneableWidget> dependentServices = [
  ProxyProvider<NetworkUtil, AuthenticationService>(
    builder: (context, api, authenticationService) => AuthenticationService(api: api),
  ),
  ProxyProvider<NetworkUtil, OrderService>(
     builder: (context, api, orderService) => OrderService(api: api),
  ),
  ChangeNotifierProxyProvider<AuthBloc,OrderViewModel>(
    builder: (context,auth,prev) => OrderViewModel(token: auth.token),
  )
];

List<SingleChildCloneableWidget> uiConsumableProviders = [
  StreamProvider<User>(
    builder: (context) => Provider.of<AuthenticationService>(context, listen: false).user,
  ),
  StreamProvider<ConnectivityStatus>.value(
    value: ConnectivityService().connectivityController.stream,
  ),
  StreamProvider<List<Promo>>.value(
    value: ps.PromoService().promoController.stream,
  ),
  ChangeNotifierProvider(
    builder:(_)=>OrderPemesanan(),
  ),
  ChangeNotifierProvider(builder: (_) => PrefsNotifier()),
  Provider(
    builder: (_) => AppBloc(),
    // dispose: (_, value){
    //   value.dispose();
    // },
  ),
  Provider(
    builder: (_) => PlaceBloc(),
    // dispose: (_,v)=>v.dispose(),

  )
  
];
  

