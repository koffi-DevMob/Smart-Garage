
import 'package:smartgmobile/model/ClientModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class APIService {

  var loginStatus = {'status':false,'netWorkStatus':false};

  Future<void> login(Users requestModel) async {
    final response = await http.post(
        Uri.parse('http://farhatfreres.asnumeric.com/api/customer/login.php',), body: requestModel.toJson());
    if (response.statusCode == 200 || response.statusCode == 400) {
      loginStatus = {'status':true,'netWorkStatus':true};
        Users user = Users.fromJson(await json.decode(response.body),);
        user.saveUserData();
      return Users.fromJson(
        await json.decode(response.body),);
    }
    else{
      return loginStatus = {'status':false,'netWorkStatus':false};
    }
  }
}