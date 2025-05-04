import 'package:flutter/cupertino.dart';
import '../models/user.model.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;
  bool get isLoggedIn => _user != null;

  void login(User user, String token) {
    _user = user;
    _token = token;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _token = null;
    notifyListeners();
  }
}