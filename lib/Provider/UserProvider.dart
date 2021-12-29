import 'dart:async';
import 'dart:convert';
import 'package:smartgmobile/model/ClientModel.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class UserProvider extends ChangeNotifier{
  String url = 'http://farhatfreres.asnumeric.com/api/customer/login.php';
  Users _user;

  Users getUserInfo(){
    return _user;
  }
  setUserInfo(Users user){
    _user = user;
    print(_user.username);
    notifyListeners();
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


  Future<dynamic> login(FormData data)async{
    isInternet();
    var body = data;
    var loginStatus = {'status':false,'netWorkStatus':false};
    Dio dio = new Dio();
    await dio.post(
      'http://farhatfreres.asnumeric.com/moncompte/api/customer/login.php',
      data: body,
    ).then((response){
      if(response.statusCode == 200){
        if(response.data['message']){
          loginStatus = {'status':true,'netWorkStatus':true};
          Users user = Users.fromMap(response.data);
          user.saveUserData();
        }else{
          loginStatus = {'status':false,'netWorkStatus':true};
        }
      }
    }
    ).catchError((error) => print(error));
    return loginStatus;
  }
}