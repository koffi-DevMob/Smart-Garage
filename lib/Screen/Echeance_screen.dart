import 'package:smartgmobile/smartgmobile_app/fitness_app_theme.dart';
import 'package:smartgmobile/const/text_style.dart';
import 'package:smartgmobile/widgets/dialogBox.dart';
import 'package:smartgmobile/widgets/loading_progress.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EcheanceScreen extends StatefulWidget {
  const EcheanceScreen({Key key}) : super(key: key);

  @override
  _EcheanceScreenState createState() => _EcheanceScreenState();
}

class _EcheanceScreenState extends State<EcheanceScreen> {

  Future<void> _launched;

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

  affiche() async {
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final int userId = sharedPreferences.getInt('userId');
    var headers = {
      'Cookie': ''
    };
    var request = http.Request('GET', Uri.parse('http://farhatfreres.asnumeric.com/moncompte/api/customer/vistechniqueexpire.php?customer_id=$userId'));
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

  DateTime _currentdate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    String _formatedate = DateFormat.yMd().format(_currentdate);
    print(_formatedate);
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.blue[700],
            title:
            Text('Visite Technique'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_sharp),
              onPressed: () {
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
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 2, bottom: 2),
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
                                          color: FitnessAppTheme.grey
                                              .withOpacity(0.2),
                                          offset: Offset(1.1, 1.1),
                                          blurRadius: 10.0),
                                    ],
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(top: 16,
                                            left: 16,
                                            right: 16,
                                            bottom: 16),
                                        child: SingleChildScrollView(
                                          child:Row(
                                            children: <Widget>[
                                              DataTable(
                                                sortColumnIndex:0,
                                                sortAscending: true,
                                                columns: [
                                                  DataColumn(label: Text('Immatricul',style: style(),)),
                                                  DataColumn(label: Text('Fin Visite',style: style(),)),
                                                  DataColumn(label: Text("Fin Assurance",style: style(),)),

                                                ],
                                                rows: model?.map((clients) {
                                                  return DataRow(
                                                      color: MaterialStateProperty.resolveWith<Color>(
                                                              (Set<MaterialState> states) {
                                                            // Even rows will have a grey color.
                                                            if (_formatedate == clients['date_exp_vistech']) {
                                                              return Colors.red.withOpacity(0.5);
                                                            }
                                                            return null; // Use default value for other states and odd rows.
                                                          }),
                                                      cells: [
                                                        DataCell(Text("${clients['immatriculation']}",style: style1(),)),
                                                        DataCell(Text("${clients['date_exp_vistech']}",style: style1(),)),
                                                        DataCell(Text("${clients['date_fin_assurance']}",style: style1(),)),
                                                        /* DataCell( ElevatedButton(
                                                          onPressed: ()=>null,
                                                          child: Text('Expiré'),
                                                          style: ElevatedButton.styleFrom(
                                                              padding: EdgeInsets.all(10),
                                                              primary: Colors.red),
                                                        ),
                                                        )*/
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
              }
            })
    );
  }
}
