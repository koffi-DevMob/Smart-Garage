import 'package:smartgmobile/smartgmobile_app/fitness_app_theme.dart';
import 'package:smartgmobile/const/text_style.dart';
import 'package:smartgmobile/widgets/dialogBox.dart';
import 'package:smartgmobile/widgets/loading_progress.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Devis_Global extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;

  const Devis_Global({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  State<Devis_Global> createState() => _Devis_GlobalState();
}

class _Devis_GlobalState extends State<Devis_Global> {


  affiche() async {
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final int userId = sharedPreferences.getInt(
        'userId');
    var headers = {
      'Cookie': 'PHPSESSID=l9eft38k5h0875r7u13cc5d4u5'
    };
    var request = http.Request('GET', Uri.parse('http://farhatfreres.asnumeric.com/moncompte/api/customer/devis.php?customer_id=$userId'));
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
    return
    FutureBuilder<dynamic>(
        future: affiche(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return LoadingProgress();
    } else {
      print(model);
      return AnimatedBuilder(
        animation: widget.animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
            opacity: widget.animation,
            child: new Transform(
              transform: new Matrix4.translationValues(
                  0.0, 30 * (1.0 - widget.animation.value), 0.0),
              child: Column(
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(
                          top: 16, left: 5, right: 5, bottom: 16),
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
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(0.0),
                                    bottomRight: Radius.circular(0.0),
                                    topRight: Radius.circular(20.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: FitnessAppTheme.grey.withOpacity(
                                          0.2),
                                      offset: Offset(1.1, 1.1),
                                      blurRadius: 10.0),
                                ],
                              ),
                              child: Padding(
                                padding:
                                const EdgeInsets.only(
                                    top: 16, left: 16, right: 16, bottom: 16),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.list, color: Colors.green,),
                                    Text("Devis",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Worksans",
                                          fontWeight: FontWeight.bold,
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(
                                  top: 16, left: 16, right: 16, bottom: 16),
                              child: Row(
                                children: <Widget>[
                                  DataTable(
                                    columns: [
                                      DataColumn(label: Text('Ref',style: style(),)),
                                      DataColumn(label: Text('Généré',style: style(),)),
                                      DataColumn(label: Text('OT',style: style(),)),
                                      DataColumn(label: Text('Immat',style: style(),)),
                                      //DataColumn(label: Text('Client',style: style(),)),
                                      //DataColumn(label: Text('Date',style: style(),)),
                                    ],
                                    rows: model?.map((clients) {
                                      return DataRow(
                                          cells: [
                                            DataCell(Text("${clients['ref_devis']}",style: style1(),)),
                                            DataCell(Text("${clients['date_devis_2']}",style: style1(),)),
                                            DataCell(Text("${clients['num_ot']}",style: style1(),)),
                                            DataCell(Text("${clients['immatriculation']}",style: style1(),)),
                                          ]
                                      );
                                    })?.toList()??[],

                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
              ),
            ),
          );
        },
      );
    }
        });
  }
}
