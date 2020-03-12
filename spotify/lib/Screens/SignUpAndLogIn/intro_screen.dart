import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'logIn_screen.dart';


import '../../Screens/SignUpAndLogIn/create_email_screen.dart';

class IntroScreen extends StatelessWidget {
  static const routeName = '/intro_screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Image.asset('assets/images/logo.jpg'),
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
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'SIGN UP FREE',
                    style: TextStyle(fontSize: 16),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.0),
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
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.face,),
                      Text(
                        'CONTINUE WITH FACEBOOK',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.0),
                    side: BorderSide(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, LogInScreen.routeName);
                  },
                ),
              ),
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

