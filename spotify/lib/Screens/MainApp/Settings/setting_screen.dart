import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:spotify/Screens/MainApp/tab_navigator.dart';
import '../tab_navigator.dart';
import '../../../Providers/user_provider.dart';
import '../../../Providers/playlist_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<UserProvider>(context, listen: false);
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(48, 44, 44, 1),
        centerTitle: true,
        title: Text(
          'Settings',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (!_auth.isUserPremium())
              Container(
                height: deviceSize.height * 0.073,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                    child: Text(
                      'Free Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: deviceSize.height * 0.0220,
                      ),
                    ),
                  ),
                ),
              ),
            if (!_auth.isUserPremium())
              Container(
                height: deviceSize.height * 0.05564,
                width: deviceSize.width * 0.39,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(TabNavigatorRoutes.premium2);
                  },
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    'GO PREMIUM',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: deviceSize.height * 0.022,
                    ),
                  ),
                ),
              ),
            ListTile(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(TabNavigatorRoutes.profileScreen);
              },
              leading: CircleAvatar(
                backgroundColor: Color.fromRGBO(27, 255, 138, 1),
                backgroundImage: _auth.getpickedImage != null
                    ? FileImage(_auth.getpickedImage)
                    : null,
                child: Text(
                  _auth.getpickedImage == null ? _auth.username[0] : "",
                  style: TextStyle(
                    color: Color.fromRGBO(20, 20, 20, 1),
                  ),
                ),
              ),
              title: Text(
                _auth.username,
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'View profile',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white,
              ),
            ),
            // ListTile(
            //   // onTap: () {},
            //   title: Text(
            //     'Notifications',
            //     style: TextStyle(
            //       color: Colors.grey,
            //     ),
            //   ),
            //   subtitle: Text(
            //     'Choose which notifications to recieve.',
            //     style: TextStyle(
            //       color: Colors.grey,
            //     ),
            //   ),
            // ),
            ListTile(
              onTap: () {
                _auth.updateFirebaseToken(_auth.token,"");
                _auth.logout();
                Provider.of<PlaylistProvider>(context, listen: false)
                    .emptyLists();
                Phoenix.rebirth(context);
              },
              title: Text(
                'Log out',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                'You are logged in as ' + _auth.username,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromRGBO(24, 20, 20, 1),
    );
  }
}
