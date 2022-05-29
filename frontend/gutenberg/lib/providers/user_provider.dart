import 'package:flutter/foundation.dart';
import '../util/requests/user_service.dart';

class UserProvider with ChangeNotifier {
  String? _username;
  bool _isAuth = false;
  String? _token;

  String? get currentUser => _username;
  set currentUser(String? username) {
    _username = username;
    notifyListeners();
  }


  bool get isAuth {
    return _isAuth;
  }

  String? get token => _token;

  Future<void> login(String username, String password) async {
    String? token = await UserService.login(
      username,
      password,
    );
    if (token!=null) {
      _isAuth = true;
      currentUser = username;
      _token = token;
    }
  }
  void logout(){
    _isAuth = false;
    currentUser = null;
    _token = null;
  }
}
