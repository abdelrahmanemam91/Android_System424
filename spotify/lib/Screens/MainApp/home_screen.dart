import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/Providers/playlist_provider.dart';
import 'package:spotify/Providers/user_provider.dart';
import 'package:spotify/Screens/SignUpAndLogIn/intro_screen.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
//import 'package:spotify/Providers/album_provider.dart';
import '../../widgets/playlist_list_widget.dart';
//import '../../widgets/album_list_widget.dart';
//import 'package:spotify/Providers/artist_provider.dart';
import '../../main.dart' as main;

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen';
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<PlaylistProvider>(context, listen: false)
          .fetchMadeForYouPlaylists();
      Provider.of<PlaylistProvider>(context, listen: false)
          .fetchPopularPlaylists();
      Provider.of<PlaylistProvider>(context, listen: false)
          .fetchWorkoutPlaylists();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 18, 18, 2),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 0,
            backgroundColor: Color.fromRGBO(18, 18, 18, 2),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  _auth.logout();
                  Phoenix.rebirth(context);

                  //main.main;
                  //Navigator.of(context).pushReplacementNamed(IntroScreen.routeName);
                },
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Column(
                  children: <Widget>[
                    PlaylistList('Made for you'),
                    PlaylistList('Popular playlists'),
                    PlaylistList('Workout'),
                    //AlbumList('Popular albums'),
                  ],
                );
              },
              childCount: 1,
            ),
          )
        ],
      ),
    );
  }
}
