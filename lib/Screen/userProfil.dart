import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartgmobile/smartgmobile_app/fitness_app_theme.dart';
import 'package:smartgmobile/widgets/dialogBox.dart';
import 'package:smartgmobile/widgets/loading_progress.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfil extends StatefulWidget {
  const UserProfil({Key key}) : super(key: key);

  @override
  _UserProfilState createState() => _UserProfilState();
}

class _UserProfilState extends State<UserProfil> {

  bool loading =false;

  @override
  void initState() {
    super.initState();
    isNet();
  }

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

  Map<String, dynamic> model;
  getClient() async {
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final int userId = sharedPreferences.getInt('userId');
    var headers = {
      'Cookie': ''
    };
    var request = http.Request('GET', Uri.parse('http://farhatfreres.asnumeric.com/moncompte/api/customer/get_customer.php?customer_id=$userId'));

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

  void launchWhatsApp({number, message}) async{
    String url= "https://wa.me/$number?text=$message";
    await canLaunch(url)? launch(url) : print("Impossible d'ouvrir");
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingProgress():Scaffold(
        appBar: AppBar(backgroundColor: Colors.blue[700],
            title:
            Text('Mon Profil'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_sharp),
              onPressed: (){
                Navigator.pushReplacementNamed(
                    context, '/home');
              },
            )
        ),

        body:FutureBuilder<dynamic>(
            future: getClient(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingProgress();
              } else {
                print(model);
                return Container(
                  child: GestureDetector(
                    child: SingleChildScrollView(
                      child: Column(
                          children:[
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 0,bottom: 0,),
                              child: SingleChildScrollView(
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      SingleChildScrollView(
                                          child:
                                              Column(
                                                children: [
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        color: FitnessAppTheme.white,
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(0.0),
                                                            bottomLeft: Radius.circular(30.0),
                                                            bottomRight: Radius.circular(30.0),
                                                            topRight: Radius.circular(0.0)),
                                                        boxShadow: <BoxShadow>[
                                                          BoxShadow(
                                                              //color: FitnessAppTheme.grey.withOpacity(0.3),
                                                              offset: Offset(1.1, 1.1),
                                                              blurRadius: 10.0),
                                                        ],
                                                      ),
                                                    child: Stack(
                                                      alignment: Alignment.bottomCenter,
                                                      overflow: Overflow.visible,
                                                      children: <Widget>[
                                                        Row(children: <Widget>[
                                                          Expanded(child:
                                                          Container(
                                                            color: Colors.grey.withOpacity(0.2),
                                                            height: 245.0,
                                                            child: Image.asset('assets/images/logo.png',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),)
                                                        ],
                                                        ),
                                                        Positioned(
                                                          top: 170.0,
                                                          child: Container(
                                                            height: 190.0,
                                                            width: 190.0,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                image: DecorationImage(
                                                                  fit: BoxFit.cover,
                                                                  image: NetworkImage('https://cdn-icons-png.flaticon.com/512/149/149071.png'),
                                                                ),
                                                                border: Border.all(
                                                                    color: Colors.white,
                                                                    width: 4.0
                                                                )
                                                            ),
                                                          ),
                                                        ),
                                                      ],)
                                                  ),
                                                  SizedBox(height: 140,),
                                                  Container(
                                                    alignment: Alignment.bottomCenter,
                                                    height: 130.0,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: <Widget>[
                                                            Text('M/Mme/Mlle', style: TextStyle(
                                                                fontSize: 20.0,
                                                              fontFamily: "Nunito"
                                                            ),),
                                                          ],
                                                        ),Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: <Widget>[
                                                            SizedBox(height: 50,),
                                                            Text(model["usr_name"], style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontFamily: "Nunito",
                                                                fontSize: 28.0
                                                            ),),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.0,),
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: <Widget>[
                                                        Column(
                                                          children: <Widget>[
                                                            IconButton(
                                                              icon: Icon(FontAwesomeIcons.whatsapp,color: Colors.green,size: 58,),
                                                              onPressed: (){
                                                                launchWhatsApp(number:"+2250777785737", message:"" );
                                                              },
                                                            ),
                                                            SizedBox(height: 15,),
                                                          ],
                                                        ),
                                                        Column(
                                                          children: <Widget>[
                                                            IconButton(
                                                              icon: Icon(Icons.location_on_outlined,color: Colors.red,size: 60,),
                                                              onPressed: (){
                                                                Navigator.pushReplacementNamed(
                                                                    context, '/maposition');
                                                              },
                                                            ),

                                                            SizedBox(height: 15,),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.0,),
                                                ],
                                              ),

                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                );
              }})
    );
  }
}
