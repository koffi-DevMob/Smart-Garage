import 'dart:convert';
import 'package:smartgmobile/smartgmobile_app/fitness_app_theme.dart';
import 'package:smartgmobile/const/text_style.dart';
import 'package:smartgmobile/widgets/dialogBox.dart';
import 'package:smartgmobile/widgets/loading_progress.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class FactureClient extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;

  const FactureClient({Key key, this.animationController, this.animation})
: super(key: key);

  @override
  _FactureClientState createState() => _FactureClientState();
}

class _FactureClientState extends State<FactureClient> {


  @override
  void initState() {
    super.initState();
    isNet();
  }

  Future<void> _launched;
  Future<void> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        enableJavaScript: true,
        forceSafariVC: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
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

  affiche() async {
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final int userId = sharedPreferences.getInt('userId');
    var headers = {
      'Cookie': ''
    };
    var request = http.Request('GET', Uri.parse('http://farhatfreres.asnumeric.com/moncompte/api/customer/facture.php?customer_id=$userId'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      model = jsonDecode(await response.stream.bytesToString());

    }
    else {
      print(response.reasonPhrase);
    }
  }

  List model;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue[700],
      title:
      Text('Mes Factures'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp),
            onPressed: (){
              Navigator.pushReplacementNamed(
                  context, '/home');
            },
          )
      ),

      body: FutureBuilder<dynamic>(
          future: affiche(),
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
                                    const EdgeInsets.only(top: 2,bottom: 1),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: FitnessAppTheme.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20.0),
                                              bottomLeft: Radius.circular(20.0),
                                              bottomRight: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0)),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: FitnessAppTheme.grey.withOpacity(0.2),
                                                offset: Offset(1.1, 1.1),
                                                blurRadius: 10.0),
                                          ],
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(top: 16, left: 16, right: 16,bottom: 16),
                                              child: SingleChildScrollView(
                                                child: Wrap(
                                                  children: <Widget>[
                                                    DataTable(
                                                      columns: [
                                                        DataColumn(label: Text('Date',style: style(),)),
                                                        DataColumn(label: Text('Vehicule',style: style(),)),
                                                        DataColumn(label: Text('Liste Facture',style: style(),)),
                                                      ],
                                                      rows: model?.map((clients) {
                                                        return DataRow(
                                                            cells: [
                                                              DataCell(Text("${clients['date_reception']}",style: style1(),)),
                                                              DataCell(Text("${clients['immatriculation']} | ${clients['marque']}",style: style1(),)),
                                                              DataCell(RaisedButton.icon(
                                                                icon: const Icon(Icons.arrow_downward,color: Colors.red,size: 30,),
                                                                label:Text("",style: TextStyle(),),
                                                                color: Colors.white,
                                                                elevation:0,
                                                                onPressed: () {
                                                                  setState(() {
                                                                    _launched = _launchInWebViewOrVC(clients['lien_fiche']);
                                                                  });
                                                                  print(clients['lien_fiche']);
                                                                },
                                                              )
                                                              ),
                                                            ]
                                                        );
                                                      })?.toList()??[],

                                                    )
                                                  ],
                                                ),
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
  Future <Null>dialog(String title)async{
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return SimpleDialog(
          title: Center(child: Text(title , textScaleFactor: 1.5,)),
          contentPadding: EdgeInsets.all(10),
          children: [
            RaisedButton(
                color:Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: (){
                  Navigator.pushReplacementNamed(
                      context, '/home');
                })
          ],);
      },
    );
  }
}
