import 'package:provider/provider.dart';

import 'models/user.dart';
import 'utils/authentication.dart';
import 'data/rest_ds.dart';
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
    builder: (context, api, authenticationService) =>
        AuthenticationService(api: api),
  )
];

List<SingleChildCloneableWidget> uiConsumableProviders = [
  StreamProvider<User>(
    builder: (context) => Provider.of<AuthenticationService>(context, listen: false).user,
  ),
];
