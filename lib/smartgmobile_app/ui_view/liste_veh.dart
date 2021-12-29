import 'package:smartgmobile/smartgmobile_app/fitness_app_theme.dart';
import 'package:smartgmobile/const/text_style.dart';
import 'package:smartgmobile/widgets/loading_progress.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class List_Veh extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;

  const List_Veh(
      {Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  State<List_Veh> createState() => _List_VehState();
}

class _List_VehState extends State<List_Veh> {



  affiche() async {
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final int userId = sharedPreferences.getInt(
        'userId');
    var headers = {
      'Cookie': 'PHPSESSID=l9eft38k5h0875r7u13cc5d4u5'
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
            return Container(
              child: GestureDetector(
                child: SingleChildScrollView(
                  child: AnimatedBuilder(
                    animation: widget.animationController,
                    builder: (BuildContext context, Widget child) {
                      return FadeTransition(
                        opacity: widget.animation,
                        child: new Transform(
                          transform: new Matrix4.translationValues(
                              0.0, 30 * (1.0 - widget.animation.value), 0.0),
                          child: Column(
                              children:[
                                Padding(
                                  padding:
                                  const EdgeInsets.only(top: 16, left: 5, right: 5,bottom: 16),
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
                                                    color: FitnessAppTheme.grey.withOpacity(0.2),
                                                    offset: Offset(1.1, 1.1),
                                                    blurRadius: 10.0),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.only(top: 16, left: 16, right: 16,bottom: 16),
                                              child: Row(
                                                children:[
                                                  Icon(Icons.list,color: Colors.green,),
                                                  Text("Véhicules à date d'assurance en échéance",
                                                      style:TextStyle(
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
                                            const EdgeInsets.only(top: 16, left: 16, right: 16,bottom: 16),
                                            child: SingleChildScrollView(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                   DataTable(
                                                     sortColumnIndex:0,
                                                     sortAscending: true,
                                                    columns: [
                                                      DataColumn(label: Text('Immatricul',style: style(),)),
                                                      //DataColumn(label: Text('VT Ech',style: style(),)),
                                                      DataColumn(label: Text("Echéance",style: style(),)),
                                                      DataColumn(label: Text('Statut Assur',style: style(),)),
                                                    ],
                                                    rows: model?.map((clients) {
                                                      return DataRow(
                                                          cells: [
                                                            DataCell(Text("${clients['immatriculation']}",style: style1(),)),
                                                            DataCell(Text("${clients['date_fin_assurance']}",style: style1(),)),
                                                            //DataCell(Text("${clients['date_exp_vistech']}",style: style1(),)),
                                                            DataCell( ElevatedButton(
                                                              onPressed: ()=>null,
                                                              child: Text('Expiré'),
                                                              style: ElevatedButton.styleFrom(
                                                              padding: EdgeInsets.all(10),
                                                              primary: Colors.red),


                                                                    ),
                                                            )
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
                      );
                    },
                  ),
                ),
              ),
            );
          }});
  }
}

class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color> colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = [];
    if (colors != null) {
      colorsList = colors ?? [];
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
