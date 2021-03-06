///Importing this package to use flutter libraries.
import 'package:flutter/material.dart';

///Importing the user provider to access the user data.
import 'package:provider/provider.dart';
import 'package:spotify/Widgets/trackPlayer.dart';
import '../../Providers/user_provider.dart';

///Importing the http exception model to throw an http exception.
import '../../Models/http_exception.dart';
import 'choose_fav_artists.screen.dart';

///This screen appears to ask the user to enter his username when signing up.
///The username filed can't be empty.
///When the user press NEXT the signing up process is called and he logs into the app.
class ChooseNameScreen extends StatefulWidget {
  static const routeName = '/choose_name_screen';
  @override
  _ChooseNameScreenState createState() => _ChooseNameScreenState();
}

class _ChooseNameScreenState extends State<ChooseNameScreen> {
  final username = TextEditingController();
  bool _validate;

  @override
  void initState() {
    _validate = true;
    super.initState();
  }

  void _showErrorDialog(String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Registration Failed'),
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

  Future<void> _submit(userData) async {
    final _auth = Provider.of<UserProvider>(context, listen: false);
    try {
      await _auth.signUp(
        userData['email'],
        userData['password'],
        userData['gender'],
        username.text,
        userData['dateOfBirth'],
      );
    } on HttpException catch (error) {
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
      return;
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
      return;
    }
    if (_auth.isLoginSuccessfully) {
      try {
        await _auth.setUser(_auth.token).then((_) {
           Navigator.of(context).popUntil(ModalRoute.withName('/intro_screen'));
           Navigator.of(context).pushNamed(ChooseFavArtists.routeName);
          //Navigator.of(context).pushReplacementNamed(MainWidget.routeName);
        });
      } on HttpException catch (error) {
        var errorMessage = error.toString();
        _showErrorDialog(errorMessage);
      } catch (error) {
        const errorMessage =
            'Could not authenticate you. Please try again later.';
        _showErrorDialog(errorMessage);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map userData = ModalRoute.of(context).settings.arguments as Map;
    final deviceSize = MediaQuery.of(context).size;
    final _user = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Theme.of(context).accentColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(deviceSize.width * 0.06, 5, 0, 10),
            child: Text(
              'What\'s your name?',
              style: TextStyle(
                  color: Colors.white, fontSize: deviceSize.width * 0.06),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: deviceSize.width * 0.06),
            width: deviceSize.width * 0.9,
            child: TextFormField(
              controller: username,
              decoration: InputDecoration(
                labelText: 'Enter your username',
                filled: true,
                fillColor: Colors.grey,
                helperText: _validate
                    ? 'This appears on your spotify profile.'
                    : 'Please enter a valid username, this username may be taken',
                helperStyle:
                    TextStyle(color: _validate ? Colors.grey : Colors.red),
                labelStyle: TextStyle(color: Colors.white38),
              ),
              style: TextStyle(color: Colors.white),
              cursorColor: Theme.of(context).primaryColor,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: deviceSize.width * 0.06),
                width: deviceSize.width * 0.4,
                height: deviceSize.height * 0.065,
                child: RaisedButton(
                  textColor: Theme.of(context).accentColor,
                  color: Colors.grey,
                  child: Text(
                    'CREATE',
                    style: TextStyle(fontSize: deviceSize.width * 0.04),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  onPressed: () {
                    if (username.text.isEmpty) {
                      setState(() {
                        _validate = false;
                      });
                    } else {
                      _submit(userData);
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
