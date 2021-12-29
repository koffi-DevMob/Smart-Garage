import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:smartgmobile/model/usermodel.dart';
import 'package:smartgmobile/widgets/Progress.dart';
import 'package:smartgmobile/widgets/dialogBox.dart';
import 'package:smartgmobile/widgets/loading_progress.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smartgmobile/const/palette.dart';
import 'package:smartgmobile/widgets/inputDeco_design.dart';
import 'package:smartgmobile/widgets/request-loader.dart';
import 'package:smartgmobile/Provider/UserProvider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';


class LoginSignupScreen extends StatefulWidget {
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {

  bool loading = false;
  bool hidePassword = true;
  bool isApiCallProcess = false;
  LoginRequestModel loginRequestModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    loginRequestModel = new LoginRequestModel();
    isNet();
  }

  Future isNet()async{
    await isInternet().then((connection) async {
      if (connection) {
        print("Internet disponible");
      }else{
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pas Internet")));
        showMyDialog(context:context,msg:'Veuillez verifier votre connexion !',route: '/');
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

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String username="",password="";
  bool isLoading = false;
  String nom="admin", mdp="admin";
  final uri = 'https://farhatfreres.asnumeric.com/api/customer/login.php';

  Connexion() async {
    if(_formkey.currentState.validate())
    {
      setState(() {
        isLoading = true;
      });
      FormData _formData = new FormData.fromMap(
          {
            "username" : username,
            "password" : password
          }

      );
    print(FormData);
      await Provider.of<UserProvider>(context,listen: false)
          .login(_formData)
          .then((res){
        print("res['user_id']:$res[]");
        if(res['status'] && res['netWorkStatus']){
          var vertest = res['firstname'];
          print('firstName:$vertest');
          isLoading=true;
          LoadingProgress();
          Navigator.pushReplacementNamed(context, '/home');
        }else if(!res['status'] && res['netWorkStatus']){
          setState(() {
            isLoading = false;
          });
          showMyDialog(context:context,msg:'Login ou mot de passe incorrect !', route:'/');
        }

        else if(!res['status'] && !res['netWorkStatus']){
          setState(() {
            isLoading = false;
          });
          showMyDialog(context:context,msg:'Login ou mot de passe incorrect  !',route: '/');
        }
      }
      );
    }
  }


  Widget _uiSetup(BuildContext context) {
    return loading
        ? LoadingProgress():Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(5), // here the desired height
          child: AppBar(
            backgroundColor:Palette.backgroundColor,
            // ...
          )
      ),

      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              bottom: 430,
              right: 10,
              left: 10,
              child: Container(

                height: MediaQuery.of(context).size.height/3.5,

                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/logo.png"),
                       fit: BoxFit.fill)
                ),
                child: Container(

                  padding: EdgeInsets.only(top: 100, left: 70),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    ],
                  ),
                ),
              ),
            ),
            Container(
                height:330,
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width - 40,
                margin: EdgeInsets.only(left: 20,right: 20,top: 220),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 5),
                    ]),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Connexion",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:  Colors.blue[900],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 3),
                                height: 3,
                                width: 55,
                                color: Colors.red,
                              )
                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Form(
                            key: _formkey,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: TextFormField(
                                      onSaved: (input) => loginRequestModel.username = input,
                                      validator: (value) {
                                        if(value.isEmpty){
                                          return 'Veuillez entrer le nom d\'utilisateur';
                                        }else{
                                          username = value;
                                          return null;
                                        }
                                      },
                                      keyboardType:TextInputType.text,
                                      decoration: buildInputDecoration(Icons.person, 'Veuillez entrer le nom d\'utilisateur')
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: TextFormField(
                                      onSaved: (input) => loginRequestModel.password = input,
                                      validator: (value) {
                                        if(value.isEmpty){
                                          return 'Veuillez entrer votre mot de passe';
                                        }else{
                                          password = value;
                                          return null;
                                        }
                                      },
                                      obscureText: true,
                                      keyboardType:TextInputType.text,
                                      decoration: buildInputDecoration(MaterialCommunityIcons.lock_outline, 'Veuillez votre nom de passe')
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: 200,
                                  height: 50,
                                  child: RaisedButton(
                                    color: Colors.blue[900],
                                    onPressed: () async{
                                      Connexion();
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.0),
                                        side: BorderSide(color: Colors.red,width:1)
                                    ),
                                    textColor:Colors.white,child: Text("Se Connecter"),

                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Column(
              children: [
                SizedBox(height: 630,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone, size: 25,color: Colors.red,),
                    Text(' 07 08 71 03 58',style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey.shade600
                    ),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    Text("Copyright © 2021 Asnumeric. All rights reserved.",style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color:Colors.grey.shade400,
                      fontFamily: "Nunito",
                      decoration: TextDecoration.underline,
                    ),),
                  ],
                )

              ],
            ),
            isLoading ? requestLoader() : SizedBox()
          ],
        ),
      ),
    );
  }
}
