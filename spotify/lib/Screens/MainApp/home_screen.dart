import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/Providers/play_history_provider.dart';
import 'package:spotify/Providers/playable_track.dart';
import 'package:spotify/Providers/playlist_provider.dart';
import 'package:spotify/Providers/user_provider.dart';

import 'package:spotify/Screens/MainApp/tab_navigator.dart';

import 'package:spotify/Providers/album_provider.dart';
import 'package:spotify/widgets/play_history_list_widget.dart';
import '../../widgets/playlist_list_widget.dart';
import '../../widgets/album_list_widget.dart';
import './tab_navigator.dart';
import 'package:connectivity/connectivity.dart';
//import 'package:spotify/Providers/artist_provider.dart';
import '../../Widgets/trackPlayer.dart';
import '../../Models/track.dart';
import '../../Models/artist.dart';
import '../../main.dart' as main;

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  bool _isInit = false;
  bool _isConnected = false;
  UserProvider user;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      user = Provider.of<UserProvider>(context, listen: false);
      Provider.of<PlayHistoryProvider>(context, listen: false)
          .fetchRecentlyPlayed();
      Provider.of<PlaylistProvider>(context, listen: false)
          .fetchPopularPlaylists(user.token);
      Provider.of<PlaylistProvider>(context, listen: false)
          .fetchMostRecentPlaylists(user.token)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });

      Provider.of<PlaylistProvider>(context, listen: false)
          .fetchPopPlaylists(user.token);
      Provider.of<PlaylistProvider>(context, listen: false)
          .fetchJazzPlaylists(user.token);
      Provider.of<PlaylistProvider>(context, listen: false)
          .fetchArabicPlaylists(user.token);
      Provider.of<PlaylistProvider>(context, listen: false)
          .fetchHappyPlaylists(user.token);
      Provider.of<AlbumProvider>(context, listen: false)
          .fetchMostRecentAlbums(user.token)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      // ;
      // Provider.of<AlbumProvider>(context, listen: false)
      //     .fetchPopularAlbums(user.token)

    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return _isLoading
        ? Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(40, 96, 65, 7.0),
                  Color(0xFF191414),
                ],
                begin: Alignment.topLeft,
                end: FractionalOffset(0.2, 0.2),
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: 0,
                    backgroundColor: Colors.transparent,
                    actions: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(TabNavigatorRoutes.settings);
                        },
                        icon: Icon(
                          Icons.settings,
                        ),
                      )
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Column(
                          children: <Widget>[
                            RecentlyPlayedList(),
                            PlaylistList(PlaylistCategory.mostRecentPlaylists),
                            PlaylistList(PlaylistCategory.popularPlaylists),
                            // AlbumList('Popular albums'),
                            //AlbumList('Most Recent Albums'),
                            PlaylistList(PlaylistCategory.pop),
                            PlaylistList(PlaylistCategory.jazz),
                            PlaylistList(PlaylistCategory.arabic),
                            PlaylistList(PlaylistCategory.happy),
                            SizedBox(
                              height: deviceSize.height * 0.1713,
                            )
                          ],
                        );
                      },
                      childCount: 1,
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
