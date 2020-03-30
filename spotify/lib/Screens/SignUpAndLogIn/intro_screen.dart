///Importing the package to use UI libraries.
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart' as fb;

///Importing the user provider to access the user data.
import 'package:provider/provider.dart';
import 'package:spotify/Widgets/trackPlayer.dart';
import '../../Providers/user_provider.dart';

///Importing the http exception model to throw an http exception.
import '../../Models/http_exception.dart';

///Importing the screens to navigate to it.
import '../../Screens/SignUpAndLogIn/create_email_screen.dart';
import 'logIn_screen.dart';

class IntroScreen extends StatefulWidget {

  static const routeName = '/intro_screen';
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {


  void _showErrorDialog(String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Logging in Failed'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {

    String email;
    final _auth=Provider.of<UserProvider>(context, listen: false);
    try {

      email=await _auth.signInWithFB();
      print(email);

    } on HttpException catch (error) {
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
      return;
    }
    if(_auth.isFbLogin)
    {
      print('LoggedIn');
      Navigator.of(context).pushNamed(MainWidget.routeName, arguments: email);
    }

  }



  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final _user = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Image.asset('assets/images/spotify_logo.jpg'),
            margin: EdgeInsets.fromLTRB(20, 50, 10, 10),
            height: deviceSize.height * 0.10,
          ),
          SizedBox(
            height: deviceSize.height * 0.15,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(25, 10, 10, 5),
            child: Text(
              'Millions of songs.',
              style: TextStyle(
                  fontSize: 30, color: Colors.white, fontFamily: 'Lineto'),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(25, 5, 10, 10),
            child: Text(
              'Free on Spotify.',
              style: TextStyle(
                  fontSize: 30, color: Colors.white, fontFamily: 'Lineto'),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: deviceSize.height * 0.20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: deviceSize.width * 0.8,
                height: deviceSize.height * 0.065,
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.green[700],
                  child: Text(
                    'SIGN UP FREE',
                    style: TextStyle(fontSize: 16),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    //side: BorderSide(color: Colors.green),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, CreateEmailScreen.routeName);
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15),
                width: deviceSize.width * 0.8,
                height: deviceSize.height * 0.065,
                child:fb.FacebookSignInButton(
                  borderRadius: 20.0,
                  onPressed: () {
                    _submit();

                  },
                )
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(

                child: Text('LOG IN', style: TextStyle(fontSize: 18, color: Colors.grey, decoration: TextDecoration.underline),),
                onPressed: (){
                  Navigator.pushNamed(context, LogInScreen.routeName);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

}

