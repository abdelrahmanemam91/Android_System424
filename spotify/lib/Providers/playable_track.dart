///Importing libraries from external packages.
import 'package:flutter/foundation.dart';
import 'package:spotify/API_Providers/trackAPI.dart';


///Import Models.
import '../Models/track.dart';

///Class PlayableTrackProvider
class PlayableTrackProvider with ChangeNotifier {

  final String baseUrl;
  PlayableTrackProvider({this.baseUrl});


  ///Song being played currently.
  Track currentSong;

  ///Indicates if a song is requested to be played.
  bool _waitingSong=false;


  ///Setting the song to requested to be played.
  void setCurrentSong(Track song){
    currentSong=song;
    _waitingSong=true;
    notifyListeners();
  }

  ///Getter for the song currently being played.
  Track getCurrentSong(){
    Track songToBeSent=currentSong;
    _waitingSong=false;
    return songToBeSent;
  }

  ///True if there is a song requested to be played.
  bool getWaitingStatus(){
    return _waitingSong;
  }


  ///Sends a http request to upgrade a user to premium.
  ///Context Uri, Track Uri and Context type must be provided.
  ///Token must be provided for authentication.
  ///An object from the API provider [TrackAPI] to send requests is created.
  Future<void> addToRecentlyPlayed(String contextUri,String trackUri, String contextType, String token) async {
    TrackAPI trackAPI = TrackAPI(baseUrl: baseUrl);
    try {
      final responseData =
      await trackAPI.addToRecentlyPlayed(contextUri,trackUri,contextType,token);
      if (responseData == true) {
        return;
      }
    } catch (error) {
      //print(error.toString());
      //throw error;
    }
  }


}
