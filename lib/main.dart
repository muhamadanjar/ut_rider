import 'package:flutter/material.dart';
import 'package:ut_order/models/auth.dart';
import 'package:ut_order/utils/constans.dart';
import 'package:ut_order/utils/custom_route.dart';
import 'routes.dart';
import 'package:provider/provider.dart';
import 'provider_setup.dart';
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
                pageTransitionsTheme: PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                    TargetPlatform.iOS: CustomPageTransitionBuilder(),
                  },
                ),
              ),
//            home: auth.isAuth
//                ? DashboardPage()
//                : FutureBuilder(
//              future: auth.tryAutoLogin(),
//              builder: (ctx, authResultSnapshot) =>
//              authResultSnapshot.connectionState == ConnectionState.waiting
//                  ? SplashScreen()
//                  : LoginPage(),
//            ),
//            home: StreamBuilder(
//              stream: auth.userSubject,
//              builder: (context,asyncSnapshot){
//                print("checking stream");
////                auth.tryAutoLogin();
//                print(asyncSnapshot.data);
//
//                if (asyncSnapshot.hasError) {
//                  return new LoginPage();
//                } else if (asyncSnapshot.data == null) {
//                  return new LoginPage();
//                }else{
//
//                  print(asyncSnapshot.data);
//                  if(asyncSnapshot.data == true){
//                    return DashboardPage();
//                  }else{
//                    auth.tryAutoLogin();
//                    return LoginPage();
//                  }
//
//
//                }
//              },
//
//          ),
            initialRoute: RoutePaths.Index,


            onGenerateRoute: Router.generateRoute,

          ),
        )
      );
  }

}

