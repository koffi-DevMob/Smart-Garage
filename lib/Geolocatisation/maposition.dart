import 'package:smartgmobile/widgets/dialogBox.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



class MaPosition extends StatefulWidget {
  const MaPosition({Key key}) : super(key: key);

  @override
  _MaPositionState createState() => _MaPositionState();
}

class _MaPositionState extends State<MaPosition> {

  bool loading = true;


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

  var mapositionactu = "";

  Future<void> getMaposition() async {
    var position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator().getLastKnownPosition();
    print(lastPosition);
    setState(() {
      mapositionactu = "$position";
    });
  }

  @override
  void initState() {
    super.initState();
    isNet();
  }

  MaPosition() async {
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final int userId = sharedPreferences.getInt('userId');
    var headers = {
      'Cookie': ''
    };
    var request = http.Request('GET',
        Uri.parse('http://farhatfreres.asnumeric.com/moncompte/api/customer/geolocalisation.php?customer_id=$userId&position=$mapositionactu'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ma Position"),
        backgroundColor: Colors.blue[700],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp),
            onPressed: (){
              Navigator.pushReplacementNamed(
                  context, '/home');
            },
          )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on_outlined, color: Colors.green,size: 80,
            ), SizedBox(height: 15,),
            Text("Signaler une panne", style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold
            )),
            SizedBox(height: 20,),

            OutlineButton(
              onPressed: null,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("En signalant une panne vous transmettriez aux techniciens de FarhatFrères votre situation géographique, afin que ceux-ci viennent vous depanner.",
                style: TextStyle(color: Colors.blue, fontFamily: "Nunito",fontWeight: FontWeight.bold),),
            ),
            ),

            SizedBox(height: 20,),
            //Text("Position: $mapositionactu"),
            FlatButton(
              color: Colors.redAccent,
                onPressed: () async {
                getMaposition();
                AlertEnvoie();
                },
                child: Text(
                  "Envoyée",style:
                    TextStyle(color: Colors.white,fontSize: 18)
                ))
          ],
        ),
      )
    );
  }
  Future <Null>dialog()async{
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return SimpleDialog(
          title: Center(child: Icon(Icons.check,size: 100,color: Colors.red,)),
          contentPadding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          children: [
            RaisedButton(
                color:Colors.grey,
                textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)),
                child: Text('OK'),
                onPressed: (){
                  Navigator.pushReplacementNamed(
                      context, '/home');
                })
          ],);
      },
    );
  }

  Future<void> AlertEnvoie() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: SingleChildScrollView(
              child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Vous allez transmettre votre ")
                      ],
                    ),Row(
                      children: [
                        Text("position pour signaler une panne ")
                      ],
                    ),Row(
                      children: [
                        Text("aux agents de FarhatFrères.")
                      ],
                    ),
                  ],
                ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text('Refuser',style: TextStyle(color: Colors.red),),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, '/home');
                  },
                ),
                TextButton(
                  child: const Text('Transmettre',style: TextStyle(color: Colors.green)),
                  onPressed: () {
                    MaPosition();
                    dialog();
                  },
                ),

              ],
            ),

          ],
        );
      },
    );
  }
}
