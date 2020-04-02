///Importing flutter material to use it's libraries.
import 'package:flutter/material.dart';

///Importing an API from facebook to use facebook login.
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

///Importing library to send http requests.
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

///Importing shared preference library to cache data.
import 'package:shared_preferences/shared_preferences.dart';

///Importing models to create objects.
import '../Models/user.dart';
import '../Models/image.dart' as img;
import '../Models/user_stats.dart';
import 'package:spotify/Models/http_exception.dart';
import '../API_Providers/userAPI.dart';

///A provider to allow the screens to access the user data.
class UserProvider with ChangeNotifier {
  final String baseUrl;
  UserProvider({this.baseUrl});

  ///SignUp and Login Attributes.
  ///
  ///Contains the current user details.
  User _user;

  ///Contains the token of the user.
  String _token;

  ///Contains the expiry date of the token.
  DateTime _expiryDate;

  ///A countdown to the expiry time.
  Timer _authTimer;

  ///Indicates if the user signed up/logged in successfully.
  bool _status;

  ///Facebook Login Attributes.
  ///An object of facebook plugin.
  var facebookLogin = FacebookLogin();

  ///Indicates if the user logs in with facebook.
  bool _isLoggedInWithFB = false;

  ///Contains the user data when logged in with facebook.
  Map userProfile;

  ///Indicates if resetting password succeeded .
  bool resetSuccessful = false;

  /* ///Constructor.
  UserProvider();*/

  ///UserInfo Getters.
  ///
  ///Returns true if the user is a premium user.
  bool isUserPremium() {
    print(_user.role);
    if (_user.role == 'premium' || _user.role == 'artist') {
      return true;
    } else {
      return false;
    }
  }

  ///Returns true if the user is an artist.
  bool isUserArtist() {
    if (_user.role == 'artist') {
      return true;
    }
    return false;
  }

  ///Returns the user's id.
  String get userId {
    return _user.id;
  }

  ///Returns the user's username.
  String get username {
    return _user.name;
  }

  ///Returns the user's email.
  String get userEmail {
    return _user.email;
  }

  ///Returns the user's images.
  List<img.Image> get userImage {
    return _user.images;
  }

  ///Returns the user's stats.
  UserStats get userStats {
    return _user.userStats;
  }

  ///Returns the user's reset password token.
  String get resetPasswordToken {
    return _user.resetPasswordToken;
  }

  ///UserInfo Setters.
  ///
  ///Setting the user to a premium/free user.
  void setPremium(String premium) {
    _user.role = premium;
  }

  ///Initializing the user data after signing up/ logging in.
  Future<void> setUser(String token) async {
    UserAPI userAPI = UserAPI(baseUrl: baseUrl);

    try {
      _user = await userAPI.setUser(_token);
      print(_user.email);
    } catch (error) {
      print(error.toString());
      throw HttpException(error.toString());
    }
  }

  ///Returns true if reset password request is successful.
  bool get isResetSuccessful {
    return resetSuccessful;
  }

  ///Return true if the login request is successful.
  bool get isLoginSuccessfully {
    return _status;
  }

  ///Returns true if the user logged in with facebook.
  bool get isFbLogin {
    return _isLoggedInWithFB;
  }

  ///AUTHENTICATION SECTION
  ///
  /// Returns true if the user is authenticated.
  bool get isAuth {
    return token != null;
  }

  ///Returns the token of the user.
  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  ///Sends a http request to signIn/signUp with facebook account.
  Future<void> signInWithFB() async {
    final result = await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=' +
                token);
        final profile = jsonDecode(graphResponse.body);
        print(profile.toString());
        print(token);
        userProfile = profile;
        _isLoggedInWithFB = true;

        String facebookId = profile['id'];

        try {
          final response = await http
              .post('http://www.mocky.io/v2/5e710a8130000086687a33e1', body: {
            "access token": token,
            "facebook id": facebookId,
          });
          final responseData = jsonDecode(response.body);

          if (responseData['message'] != null) {
            throw HttpException(responseData['message']);
          } else {
            _token = responseData['token'];
            _status = responseData['success'];
            print(_token.toString());
            _expiryDate = DateTime.now().add(Duration(days: 1));
            _autoLogout();
            notifyListeners();
            final prefs = await SharedPreferences.getInstance();
            final userData = json.encode(
              {
                'token': _token,
                'expiryDate': _expiryDate.toIso8601String(),
              },
            );
            print('FacebookLoginDone');
            prefs.setString('userData', userData);
          }
        } catch (error) {
          throw HttpException(error.toString());
        }
        break;

      case FacebookLoginStatus.cancelledByUser:
        _isLoggedInWithFB = false;
        return 'FBLogin Failed';
        break;
      case FacebookLoginStatus.error:
        _isLoggedInWithFB = false;
        return 'FBLogin Failed';
        break;
    }
  }

  ///Sends a request to signUp a new user.
  Future<void> signUp(String email, String password, String gender,
      String username, String dateOfBirth) async {
    UserAPI userAPI = UserAPI(baseUrl: baseUrl);

    try {

      final responseData = await userAPI.signUp(email, password, gender, username, dateOfBirth);

      if (responseData['message'] != null) {
        throw HttpException(responseData['message']);
      } else {
        _token = responseData['token'];
        _status = responseData['success'];
        print(_token.toString());
        _expiryDate = DateTime.now().add(Duration(days: 1));
        _autoLogout();
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'token': _token,
            'expiryDate': _expiryDate.toIso8601String(),
          },
        );
        print(responseData);
        print('SignUpDone');
        prefs.setString('userData', userData);
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  ///Sends a request to signUp a new user with facebook.
  Future<void> signUpWithFB(
      String email, String password, String username) async {
    final url = 'http://www.mocky.io/v2/5e710a8130000086687a33e1';

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "email": email,
            "password": password,
            "username": username,
          },
        ),
      );

      final responseData = jsonDecode(response.body);

      if (responseData['message'] != null) {
        throw HttpException(responseData['message']);
      } else {
        _token = responseData['token'];
        _status = responseData['success'];
        print(_token.toString());
        _expiryDate = DateTime.now().add(Duration(days: 1));
        _autoLogout();
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'token': _token,
            'expiryDate': _expiryDate.toIso8601String(),
          },
        );
        _isLoggedInWithFB = true;
        print('SignUpFBDone');
        prefs.setString('userData', userData);
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  ///Sends a http request to sign in a user.
  Future<void> signIn(String email, String password) async {
//    final url = 'https://97b7d966-bab5-4a82-ac2d-ae47d01c3c58.mock.pstmn.io/signIn';
    UserAPI userAPI = UserAPI(baseUrl: baseUrl);

    try {
      final responseData = await userAPI.signIn(email, password);
      if (responseData['message'] != null) {
        throw HttpException(responseData['message']);
      } else {
        _token = responseData['token'];
        _status = responseData['success'];
        _expiryDate = DateTime.now().add(Duration(days: 1));
        _autoLogout();
        notifyListeners();
        print(responseData);
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'token': _token,
            'expiryDate': _expiryDate.toIso8601String(),
          },
        );
        prefs.setString('userData', userData);
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  ///Sends a request to send an email to create a new password.
  Future<void> forgetPassword(String email) async {
    final url = 'http://www.mocky.io/v2/5e710d6630000086687a33f8';

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "email": email,
          },
        ),
      );

      final responseData = jsonDecode(response.body);

      if (responseData['status'] != 304) {
        throw HttpException(responseData['message']);
      } else {
        resetSuccessful = true;
        print(responseData['message']);
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  ///Checks if the token cached is valid or not.
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _expiryDate = expiryDate;
    await setUser(_token);
    notifyListeners();
    _autoLogout();
    return true;
  }

  ///Nullify the data of the user to log him out.
  Future<void> logout() async {
    _token = null;
    _status = null;
    _expiryDate = null;
    _user = null;
    _isLoggedInWithFB = null;
    _authTimer = null;
    print('token expires');
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  ///Nullify the user automatically and reset the timer to log him out.
  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
