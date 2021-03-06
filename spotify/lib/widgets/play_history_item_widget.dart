import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:spotify/Models/play_history.dart';
import 'package:spotify/Providers/album_provider.dart';
import 'package:spotify/Providers/playlist_provider.dart';
import 'package:spotify/Screens/Albums/albums_list_screen.dart';
import 'package:spotify/Screens/Playlists/playlists_list_screen.dart';

class PlayHistoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playhistory = Provider.of<PlayHistory>(context);
    final deviceSize = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        if (playhistory.context.type == "artist") {
        } else if (playhistory.context.type == "playlist") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlaylistsListScreen(
                playlistId: playhistory.context.id,
                playlistType: PlaylistCategory.recentlyPlayed,
              ),
            ),
          );
        } else if (playhistory.context.type == "album") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AlbumsListScreen(
                albumType: AlbumCategory.recentlyPlayed,
                albumId: playhistory.context.id,
                artistName: "",
              ),
            ),
          );
        }
      },
      child: Container(
        height: deviceSize.height * 0.317,
        width: deviceSize.width * 0.341,
        child: Column(
          children: <Widget>[
            Container(
              height: deviceSize.height * 0.205,
              width: deviceSize.width * 0.341,
              child: playhistory.context.type == "artist"
                  ? ClipRRect(
                      borderRadius:
                          BorderRadius.circular((deviceSize.width * 0.341) / 2),
                      child: FadeInImage(
                        image: NetworkImage(playhistory.context.image[0]),
                        placeholder: AssetImage('assets/images/temp.jpg'),
                        fit: BoxFit.fill,
                      ),
                    )
                  : FadeInImage(
                      image: NetworkImage(playhistory.context.image[0]),
                      placeholder: AssetImage('assets/images/temp.jpg'),
                      fit: BoxFit.fill,
                    ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: deviceSize.height * 0.0147,
              ),
              height: deviceSize.height * 0.0219,
              width: double.infinity,
              child: Text(
                playhistory.context.name,
                overflow: TextOverflow.ellipsis,
                textAlign: playhistory.context.type == "artist"
                    ? TextAlign.center
                    : TextAlign.left,
                style: TextStyle(
                  fontSize: deviceSize.width * 0.0292,
                  color: Colors.white,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
