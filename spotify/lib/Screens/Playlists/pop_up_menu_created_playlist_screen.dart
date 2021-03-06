import 'package:flutter/cupertino.dart';

///Importing this package to use flutter libraries.
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:spotify/Models/playlist.dart';
import 'package:spotify/Providers/playlist_provider.dart';
import 'package:spotify/Screens/Library/add_song_to_playlist_screen.dart';

///Importing the user provider to access the user data.
import 'package:provider/provider.dart';
//import '../../Providers/user_provider.dart';

class PopUpMenuCreatedPlaylistScreen extends StatefulWidget {
  static const routeName = '/pop_up_menu_playlist_screen';
  final Playlist playlist;
  PopUpMenuCreatedPlaylistScreen(this.playlist);

  @override
  _PopUpMenuCreatedPlaylistScreenState createState() =>
      _PopUpMenuCreatedPlaylistScreenState();
}

class _PopUpMenuCreatedPlaylistScreenState
    extends State<PopUpMenuCreatedPlaylistScreen> {
  ///Initializations.
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///Getting the device size.
    final deviceSize = MediaQuery.of(context).size;
    //final user = Provider.of<UserProvider>(context, listen: false);
    //final playlistProvider =
        Provider.of<PlaylistProvider>(context, listen: false);

    ///If the screen is loading show a circular progress.
    return Scaffold(
        backgroundColor: Colors.black12,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: FadeInImage(
                        image:
                            NetworkImage(widget.playlist.tracks[0].album.image),
                        placeholder: AssetImage('assets/images/temp.jpg'),
                        height: deviceSize.height * 0.3,
                      ),
                      margin: EdgeInsets.only(
                        top: deviceSize.height * 0.1,
                      ),
                    ),
                    Container(
                      child: Text(
                        widget.playlist.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: deviceSize.width * 0.04),
                      ),
                      margin: EdgeInsets.only(
                          top: deviceSize.height * 0.01,
                          bottom: deviceSize.height * 0.01),
                    ),
                    Container(
                      child: Text(
                        widget.playlist.owner[0].name,
                        style: TextStyle(
                            color: Colors.white60,
                            fontSize: deviceSize.width * 0.035),
                      ),
                      margin: EdgeInsets.only(
                          top: deviceSize.height * 0.005,
                          bottom: deviceSize.height * 0.05),
                    ),
                    Container(
                      child: InkWell(
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Icon(
                                Icons.add_circle,
                                color: Colors.white,
                                size: deviceSize.height * 0.058565,
                              ),
                              margin: EdgeInsets.fromLTRB(
                                deviceSize.width * 0.04866,
                                deviceSize.height * 0.02928,
                                deviceSize.width * 0.012165,
                                deviceSize.height * 0.02928,
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.fromLTRB(
                                  deviceSize.width * 0.09732,
                                  deviceSize.height * 0.02928,
                                  deviceSize.width * 0.02433,
                                  deviceSize.height * 0.02928,
                                ),
                                child: Text(
                                  'Add songs',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: deviceSize.width * 0.05),
                                ))
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddSongToPlaylistScreen(widget.playlist.id),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      child: InkWell(
                        onTap: () async {
                          await Share.share(
                              'Check Out This Album On Totally Not Spotify ' +
                                  widget.playlist.href.replaceAll('/api', ''));
                        },
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                              margin: EdgeInsets.fromLTRB(
                                deviceSize.width * 0.04866,
                                deviceSize.height * 0.02928,
                                deviceSize.width * 0.012165,
                                deviceSize.height * 0.02928,
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.fromLTRB(
                                  deviceSize.width * 0.09732,
                                  deviceSize.height * 0.02928,
                                  deviceSize.width * 0.02433,
                                  deviceSize.height * 0.02928,
                                ),
                                child: Text(
                                  'Share this playlist',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: deviceSize.width * 0.05),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: FlatButton(
                        child: Text(
                          'CLOSE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: deviceSize.width * 0.035,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: deviceSize.height * 0.073206),
          ],
        ));
  }
}
