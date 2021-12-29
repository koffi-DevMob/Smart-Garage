import 'package:shared_preferences/shared_preferences.dart';

class Users {
  bool message;
  String username;
  String firstname;
  int userId;
  String sessionCookie;
  String password;

  Users(
      {this.message,
        this.username,
        this.firstname,
        this.userId,
        this.sessionCookie,
        this.password});

  Users.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    username = json['username'];
    firstname = json['firstname'];
    userId = json['user_id'];
    sessionCookie = json['session_cookie'];
    password = json['password'];
  }

  factory Users.fromMap(Map<String,dynamic> map){
    if(map==null) return null;

    return Users(
        userId: map['user_id'],
        username: map['username'],
        password: map['password'],
        firstname: map['firstname'],
        message: map['message'],
        sessionCookie: map['session_cookie'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['username'] = this.username;
    data['firstname'] = this.firstname;
    data['user_id'] = this.userId;
    data['session_cookie'] = this.sessionCookie;
    data['password'] = this.password;
    return data;
  }

  saveUserData() async
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('userId', this.userId );
    sharedPreferences.setString('username', this.username);
    sharedPreferences.setString('password', this.password);
    sharedPreferences.setString('firstname', this.firstname);
    //sharedPreferences.setString('session_cookie', this.sessionCookie);
  }
}