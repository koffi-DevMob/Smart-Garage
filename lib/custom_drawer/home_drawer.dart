import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:smartgmobile/const/app_theme.dart';
import 'package:smartgmobile/widgets/dialogBox.dart';
import 'package:smartgmobile/widgets/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key key, this.screenIndex, this.iconAnimationController, this.callBackIndex}) : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {


  Future isNet()async{
    await isInternet().then((connection) async {
      if (connection) {
        print("Internet disponible");
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pas Internet")));
        showMyDialog(context:context,msg:'Veuillez verifier votre connexion !',route: '/home');
      }
    });
  }

  static Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (await DataConnectionChecker().hasConnection) {
        print("Mobile data detected & internet connection confirmed.");
        return true;
      } else {
        print('No internet');
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (await DataConnectionChecker().hasConnection) {
        print("wifi data detected & internet connection confirmed.");
        return true;
      } else {
        print('No internet');
        return false;
      }
    } else {
      print(
          "Neither mobile data or WIFI detected, not internet connection found.");
      return false;
    }
  }


  List<DrawerList> drawerList;
  @override
  void initState() {
    setDrawerListArray();
    super.initState();
    //isNet();
  }

  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.Acceuil,
        labelName: 'Tableau de bord',
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.Fiches_recep,
        labelName: 'Mes Réceptions',
        icon: Icon(Icons.assignment_sharp)
      ),
      DrawerList(
        index: DrawerIndex.Devis,
        labelName: 'Mes Devis',
        icon: Icon(Icons.assignment_sharp)
      ),DrawerList(
        index: DrawerIndex.Echeance,
        labelName: 'Visite Technique',
        icon: Icon(Icons.settings_rounded)
      ),
      DrawerList(
        index: DrawerIndex.Factures,
        labelName: 'Mes Factures',
        icon: Icon(Icons.assignment_turned_in),
      ),
      // DrawerList(
      //   index: DrawerIndex.Reception,
      //   labelName: 'Réception',
      //   icon: Icon(Icons.group),
      // ),
      // DrawerList(
      //   index: DrawerIndex.Echeance,
      //   labelName: 'Date d\'écheance',
      //   icon: Icon(Icons.web_asset_rounded),
      // ),
    ];
  }

  Map<String, dynamic> model;
  getClient() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final int userId = sharedPreferences.getInt('userId');
    var headers = {'Cookie': ''};
    var request = http.Request('GET',
        Uri.parse('http://farhatfreres.asnumeric.com/moncompte/api/customer/get_customer.php?customer_id=$userId'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map<String, dynamic> map =jsonDecode(await response.stream.bytesToString());
      model=map;
    }
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      body: FutureBuilder<dynamic>(
        future: getClient(),
       builder: (BuildContext context, AsyncSnapshot snapshot) {
         //print(model);
         return Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           mainAxisAlignment: MainAxisAlignment.start,
           children: <Widget>[
             Container(
               width: double.infinity,
               padding: const EdgeInsets.only(top: 40.0),
               child: Container(
                 padding: const EdgeInsets.all(16.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: <Widget>[
                     AnimatedBuilder(
                       animation: widget.iconAnimationController,
                       builder: (BuildContext context, Widget child) {
                         return ScaleTransition(
                           scale: AlwaysStoppedAnimation<double>(1.0 -
                               (widget.iconAnimationController.value) * 0.2),
                           child: RotationTransition(
                             turns: AlwaysStoppedAnimation<double>(
                                 Tween<double>(begin: 0.0, end: 24.0)
                                     .animate(CurvedAnimation(
                                     parent: widget.iconAnimationController,
                                     curve: Curves.fastOutSlowIn))
                                     .value /
                                     360),
                             child: Container(
                               height: 120,
                               width: 150,
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 boxShadow: <BoxShadow>[
                                   BoxShadow(
                                       color: AppTheme.grey.withOpacity(0.01),
                                       offset: const Offset(2.0, 4.0),
                                       blurRadius: 8),
                                 ],
                               ),
                               child: ClipRRect(
                                 borderRadius: const BorderRadius.all(
                                     Radius.circular(70.0)),
                                 child: Image.asset('assets/images/logo.png'),
                               ),
                             ),
                           ),
                         );
                       },
                     ),
                     Padding(
                         padding: const EdgeInsets.only(top: 8, left: 4),
                         child: Text.rich(
                           TextSpan(
                             text: 'Bienvenue ',
                             style: TextStyle(
                               fontFamily: "Worksans",
                               fontSize: 16,
                               fontWeight: FontWeight.bold,
                             ),
                             children: [
                              TextSpan(text:model["usr_name"],
                                   style: TextStyle(
                                       fontWeight: FontWeight.bold,
                                       fontSize: 16
                                   ))
                             ],
                           ),
                         )
                     ),
                   ],
                 ),
               ),
             ),
             const SizedBox(
               height: 4,
             ),
             Divider(
               height: 1,
               color: AppTheme.grey.withOpacity(0.6),
             ),
             Expanded(
               child: ListView.builder(
                 physics: const BouncingScrollPhysics(),
                 padding: const EdgeInsets.all(0.0),
                 itemCount: drawerList?.length,
                 itemBuilder: (BuildContext context, int index) {
                   return inkwell(drawerList[index]);
                 },
               ),
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text("Copyright © 2021 Asnumeric. All rights reserved.",style: TextStyle(
                   fontSize: 10,
                   fontWeight: FontWeight.bold,
                   color:Colors.grey.shade600,
                   fontFamily: "Nunito",
                 ),),
               ],
             ),
             SizedBox(height: 5,),
             Divider(
               height: 1,
               color: AppTheme.grey.withOpacity(0.6),
             ),
             Column(
               children: <Widget>[
                 ListTile(
                   title: Text(
                     'Se deconnecter',
                     style: TextStyle(
                       fontFamily: AppTheme.fontName,
                       fontWeight: FontWeight.w600,
                       fontSize: 16,
                       color: AppTheme.darkText,
                     ),
                     textAlign: TextAlign.left,
                   ),
                   trailing: Icon(
                     Icons.power_settings_new,
                     color: Colors.red,
                   ),
                   onTap: () async {
                     final SharedPreferences sharedPreferences =
                     await SharedPreferences.getInstance();
                     sharedPreferences.remove('userId');
                     sharedPreferences.remove('userName');
                     sharedPreferences.remove('firstName');
                     LoadingProgress();
                     Navigator.of(context).pushReplacementNamed('/');
                   },
                 ),
                 SizedBox(
                   height: MediaQuery
                       .of(context)
                       .padding
                       .bottom,
                 )
               ],
             ),
           ],
         );
       }
        )
    );
  }
  
  /*void onTapped() {
    Navigator.pushReplacementNamed(context, '/'); // Print to console.
  }*/

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName, color: widget.screenIndex == listData.index ? Colors.blue : AppTheme.nearlyBlack),
                        )
                      : Icon(listData.icon?.icon, color: widget.screenIndex == listData.index ? Colors.redAccent : AppTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index ? Colors.blue[900] : AppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) * (1.0 - widget.iconAnimationController.value - 1.0), 0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
}

enum DrawerIndex {
  Acceuil,
  Fiches_recep,
  Devis,
  Factures,
  Echeance,

}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}
