// @dart=2.9
import 'dart:io';
import 'package:smartgmobile/Screen/Echeance_screen.dart';
import 'package:smartgmobile/Screen/userProfil.dart';
import 'package:smartgmobile/const/app_theme.dart';
import 'package:smartgmobile/Screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'Geolocatisation/maposition.dart';
import 'Provider/UserProvider.dart';
import 'Screen/Devis_screen.dart';
import 'Screen/facture_screen.dart';
import 'Screen/fich_recep.dart';
import 'Screen/navigation_home_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:smartgmobile/Wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(),)
      ],
      child: MaterialApp(
        title: 'smartgmobile',
        debugShowCheckedModeBanner: false,
          initialRoute:'/',
          routes: {
            '/': (context) => Wrapper(),
            '/home': (context) => NavigationHomeScreen(),
            '/maposition': (context) => MaPosition(),
            '/mesdevis': (context) => DevisScreen(),
            '/mesreception': (context) => VehiculeScreen(),
            '/mesfactures': (context) => FactureClient(),
            '/assurance': (context) => EcheanceScreen(),
            '/profil': (context) => UserProfil(),

          },
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: AppTheme.textTheme,
          platform: TargetPlatform.iOS,
        ),
       // home: NavigationHomeScreen(),
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
