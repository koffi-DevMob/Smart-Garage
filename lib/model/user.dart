import 'package:shared_preferences/shared_preferences.dart';

class User{
  final int id;
  final String firstName;

  User({
    this.id,
    this.firstName,
  });
  
  factory User.fromMap(Map<String,dynamic> map){
    if(map==null) return null;
    return User(
        id: map['user_id'],
        firstName: map['firstname'],
    );
  }

  saveUserData() async
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('userId', this.id );
    sharedPreferences.setString('firstname', this.firstName );
  }
}
