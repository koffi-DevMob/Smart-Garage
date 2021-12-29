import 'package:smartgmobile/smartgmobile_app/ui_view/Recep_client.dart';
import 'package:smartgmobile/smartgmobile_app/ui_view/devis_global.dart';
import 'package:smartgmobile/smartgmobile_app/ui_view/liste_veh.dart';
import 'package:smartgmobile/smartgmobile_app/fitness_app_theme.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';

class MyDiaryScreen extends StatefulWidget {
  const MyDiaryScreen({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _MyDiaryScreenState createState() => _MyDiaryScreenState();
}

class _MyDiaryScreenState extends State<MyDiaryScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
    isNet();
  }

  // verificatio de connexion
  Future isNet()async{
    await isInternet().then((connection) async {
      if (connection) {
        print("Internet disponible");
      }else{
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pas Internet")));
        //showMyDialog(context:context,msg:'Veuillez verifier votre connexion !',route: '/home');
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

  void addAllListData() {
    const int count = 9;


    listViews.add(
      Recep_Client(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      Devis_Global(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    //LIste de vehicule d'echeance
    listViews.add(
      List_Veh(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );



  }
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            //getAppBarUI(),
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10,top: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("APPLICATION DE GESTION DE GARAGE",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Tahoma",
                  fontWeight: FontWeight.bold,
                ),
                )],
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox.fromSize(
                        size: Size(130, 130), // button width and height
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(100.0),
                                bottomLeft: Radius.circular(100.0),
                                bottomRight: Radius.circular(100.0),
                                topRight: Radius.circular(100.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: FitnessAppTheme.grey.withOpacity(0.8),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: ClipOval(
                            child: Material(
                              color: Colors.red, // button color
                              child: InkWell(
                                splashColor: Colors.blue[800], // splash color
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/maposition');
                                }, // button pressed
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.location_on_outlined,size: 60,color: Colors.white,), // icon
                                    Text('Signaler', style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Worksans"
                                    ),),
                                    Text('une panne', style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Worksans"
                                    ),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      /*Container(
                          height: 140,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(100.0),
                                bottomLeft: Radius.circular(100.0),
                                bottomRight: Radius.circular(100.0),
                                topRight: Radius.circular(100.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: FitnessAppTheme.grey.withOpacity(0.8),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20, left: 12),
                                child: RaisedButton.icon(
                                  icon: const Icon(Icons.location_on_outlined,size: 65,color: Colors.white,),
                                  elevation: 0,
                                  color: Colors.red,
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/maposition');
                                  },
                                  label: Text(""),
                                ),
                              ),
                              SizedBox(height: 3,),
                              Text('Signaler', style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Worksans"
                              ),),
                              Text('une panne', style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Worksans"
                              ),),
                            ],
                          )
                      ),*/
                      SizedBox(height: 50,),
                      Row(
                        children: [
                          Expanded(
                              child:Container(
                                height: 140,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.blue[900],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: FitnessAppTheme.grey.withOpacity(1),
                                        offset: Offset(1.1, 1.1),
                                        blurRadius: 10.0),
                                  ],
                                ),
                                  child:Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 30, left: 12),
                                        child: RaisedButton.icon(
                                          icon: const Icon(Icons.article_outlined,size: 65,color: Colors.white,),
                                          color: Colors.blue[900],
                                          elevation: 0,
                                          onPressed: () {
                                            Navigator.pushReplacementNamed(
                                                context, '/mesreception');
                                          },
                                          label: Text(""),
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text('Mes Réceptions', style: TextStyle(
                                          color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Worksans"
                                      ),)
                                    ],
                                  ),

                              )
                          ),
                          SizedBox(width: 20,),
                          Expanded(
                            child: Container(
                              height: 140,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.blue[900],
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: FitnessAppTheme.grey.withOpacity(1),
                                      offset: Offset(1.1, 1.1),
                                      blurRadius: 10.0),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30, left: 12),
                                    child: RaisedButton.icon(
                                      icon: const Icon(Icons.assignment_outlined,size: 65,color: Colors.white,),
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                            context, '/mesdevis');
                                      },
                                      color: Colors.blue[900],
                                      label: Text(""),
                                      elevation: 0,
                                      ),
                                    ),

                                  SizedBox(height: 5,),
                                  Text('Mes Devis', style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Worksans"
                                  ),)
                                ],
                              )
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                              child:Container(
                                height: 140,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.blue[900],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0)),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: FitnessAppTheme.grey.withOpacity(1),
                                        offset: Offset(1.1, 1.1),
                                        blurRadius: 10.0),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 30, left: 12),
                                      child: RaisedButton.icon(

                                        icon: const Icon(Icons.assignment_turned_in_outlined,size: 65,color: Colors.white,),
                                        color: Colors.blue[900],
                                        elevation: 0,
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context, '/mesfactures');
                                        },
                                        label: Text(""),
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text('Mes Factures', style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Worksans"
                                    ),)
                                  ],
                                )
                              )
                          ),
                          SizedBox(width: 20,),
                          Expanded(
                            child: Container(
                              height: 140,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.blue[900],
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: FitnessAppTheme.grey.withOpacity(1),
                                      offset: Offset(1.1, 1.1),
                                      blurRadius: 10.0),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30, left: 12),
                                    child: RaisedButton.icon(
                                    icon: const Icon(Icons.settings_outlined,size: 65,color: Colors.white,),
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                            context, '/assurance');
                                      },
                                      color:Colors.blue[900],
                                      label: Text(""),
                                      elevation: 0,
                                      ),
                                    ),

                                  SizedBox(height: 5,),
                                  Text('Visites Tech', style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Worksans"
                                  ),)
                                ],
                              )
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return
          Positioned(
            child: Container(
               decoration: BoxDecoration(
            image: DecorationImage(
            image: AssetImage("assets/images/logo.png"),
                colorFilter:
                ColorFilter.mode(
                    Colors.white.withOpacity(0.1),
                    BlendMode.dstATop),
        fit: BoxFit.fill)
        ),
            ),
          );
            Image.asset("assets/images/mecanicien.jpg");
            /*ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top:5,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          )*/;
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FitnessAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom:10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Text(
                                  'Livraison',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: FitnessAppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 30,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: FitnessAppTheme.grey,
                                      size: 18,
                                    ),
                                  ),
                                  Text(
                                    '15 Mai',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      letterSpacing: -0.2,
                                      color: FitnessAppTheme.darkerText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
