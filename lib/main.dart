import 'package:flutter/material.dart';
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
        child:MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: RoutePaths.Login,
          onGenerateRoute: Router.generateRoute,

        )
      );
  }
}

