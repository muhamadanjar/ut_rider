import 'package:provider/provider.dart';
import 'package:ut_order/utils/prefs.dart';

import 'data/app_bloc.dart';
import 'data/place_bloc.dart';
import 'models/user.dart';
import 'utils/authentication.dart';
import 'data/rest_ds.dart';
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
  Provider.value(value: RestDatasource()),
];

List<SingleChildCloneableWidget> dependentServices = [
  ProxyProvider<RestDatasource, AuthenticationService>(
    builder: (context, api, authenticationService) => AuthenticationService(api: api),
  ),
  ProxyProvider<RestDatasource, OrderService>(
     builder: (context, api, orderService) => OrderService(api: api),
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
    dispose: (_, value){
      value.dispose();
    },
  ),
  Provider(
    builder: (_) => PlaceBloc(),
    dispose: (_,v)=>v.dispose(),

  )
  
];
  

