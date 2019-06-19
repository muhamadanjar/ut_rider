import 'package:provider/provider.dart';

import 'models/user.dart';
import 'utils/authentication.dart';
import 'data/rest_ds.dart';
import 'utils/connectivity.dart';
import 'enum/connection_status.dart';
import 'models/order.dart';
import 'utils/order.dart';
List<SingleChildCloneableWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders,
];

List<SingleChildCloneableWidget> independentServices = [
  Provider.value(value: RestDatasource())
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
  StreamProvider<Order>.value(
    value: OrderService().orderController.stream,
  ),
  
];
  

