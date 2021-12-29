import 'package:smartgmobile/const/app_theme.dart';
import 'package:smartgmobile/custom_drawer/drawer_user_controller.dart';
import 'package:smartgmobile/custom_drawer/home_drawer.dart';
import 'package:smartgmobile/Screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:smartgmobile/widgets/loading_progress.dart';
import 'Devis_screen.dart';
import 'Echeance_screen.dart';
import 'facture_screen.dart';
import 'fich_recep.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;
  bool loading = false;

  @override
  void initState() {
    drawerIndex = DrawerIndex.Acceuil;
    screenView = const MyHomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingProgress(): Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.Acceuil) {
        setState(() {
          screenView = const MyHomePage();
        });
      } else if (drawerIndex == DrawerIndex.Fiches_recep) {
        setState(() {
          screenView =VehiculeScreen();
        });
      }else if (drawerIndex == DrawerIndex.Devis) {
        setState(() {
          screenView =DevisScreen();
        });
      }else if (drawerIndex == DrawerIndex.Echeance) {
        setState(() {
          screenView =EcheanceScreen();
        });
      } else if (drawerIndex == DrawerIndex.Factures) {
        setState(() {
          screenView = FactureClient();
        });
      // } else if (drawerIndex == DrawerIndex.Reception) {
      //   setState(() {
      //     screenView = InviteFriend();
      //   });
      // } else if (drawerIndex == DrawerIndex.Echeance) {
      //   setState(() {
      //     screenView = EcheanceScreen();
      //   });
      } else {
        //do in your way......
      }
    }
  }
}
