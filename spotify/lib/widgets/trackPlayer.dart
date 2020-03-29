import 'package:flutter/material.dart';
import 'package:spotify/Models/artist.dart';
import '../Models/track.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:io';
import 'collapsed.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'panel.dart';
import 'seekBar.dart';
import '../Screens/MainApp/tab_navigator.dart';
import '../Screens/MainApp/bottom_navigation_bar.dart';


class TrackPlayer extends StatefulWidget {

  List<Track> playlist=[Track(
      id:'1',
      name:'Sahran',
      album: 'Sahran',
      artists: [Artist(
        name: 'Amr Diab',
        bio: '',
      )],
      imgUrl: 'https://i1.sndcdn.com/artworks-000685259938-at3rot-t500x500.jpg',
      href:'https://nogomistars.com/Online_Foldern/Amr_Diab/Sahraan/Nogomi.com_Amr_Diab-02.Sahran.mp3',
      trackNumber: 1
  ),
  Track(
    id:'2',
    name:'Gamda Bas',
    album: 'Sahran',
    artists: [Artist(
      name: 'Amr Diab',
      bio: '',
    )],
    imgUrl: 'https://i1.sndcdn.com/artworks-000685259938-at3rot-t500x500.jpg',
    href:'https://nogomistars.com/Online_Foldern/Amr_Diab/Sahraan/Nogomi.com_Amr_Diab-01.Gamda_Bas.mp3',
    trackNumber: 2
  )
  ];
  int trackNumber=1;
  TrackPlayer();////this.playlist, this.trackNumber});
  @override
  _TrackPlayerState createState() => _TrackPlayerState();

}

class _TrackPlayerState extends State<TrackPlayer> {
  ///Sliding panel attributes.
  final double _initFabHeight = 120;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed;
  var panelState;



  PanelController _pc = new PanelController();
  PaletteGenerator paletteGenerator;

  Color back;

  ///Song attributes
  Track song;
  AudioPlayer _player;
  String songPath;
  bool downloading;


  static TabItem _currentTab = TabItem.home;

  static Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.search: GlobalKey<NavigatorState>(),
    TabItem.library: GlobalKey<NavigatorState>(),
    TabItem.premium: GlobalKey<NavigatorState>(),
    TabItem.artist: GlobalKey<NavigatorState>(),
  };

  final List<Widget> pages = [
    TabNavigator(
      route: TabNavigatorRoutes.search,
      navigatorKey: _navigatorKeys[TabItem.home],
      tabItem: TabItem.home,
    ),

    TabNavigator(
      route: TabNavigatorRoutes.search,
      navigatorKey: _navigatorKeys[TabItem.search],
      tabItem: TabItem.search,
    ),
    TabNavigator(
      route: TabNavigatorRoutes.library,
      navigatorKey: _navigatorKeys[TabItem.library],
      tabItem: TabItem.library,
    ),
    TabNavigator(
      route: TabNavigatorRoutes.premium,
      navigatorKey: _navigatorKeys[TabItem.premium],
      tabItem: TabItem.premium,
    ),
    TabNavigator(
      route: TabNavigatorRoutes.artist,
      navigatorKey: _navigatorKeys[TabItem.artist],
      tabItem: TabItem.artist,
    ),
  ];
  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
    setState(() => _currentTab = tabItem);
  }

  ///Initializations
  @override
  void initState() {
    super.initState();
    init();
  }

  void init(){
    if(widget.playlist.length<widget.trackNumber)
      widget.trackNumber=1;
    song = widget.playlist.firstWhere((x)=>x.trackNumber==widget.trackNumber);
    panelState = PanelState.CLOSED;
    _fabHeight = _initFabHeight;
    _generatePalette();
    _player = AudioPlayer();
    downloading=true;
    downloadSong();
  }

  Future<void> _generatePalette() async {
    PaletteGenerator _paletteGenerator =
    await PaletteGenerator.fromImageProvider(NetworkImage(song.imgUrl),
        size: Size(110, 150), maximumColorCount: 20);
    back = _paletteGenerator.darkMutedColor.color;

    setState(
          () {
        paletteGenerator = _paletteGenerator;
      },
    );
  }

  Future<void> downloadSong() async {
    Dio dio= new Dio();
    var dir = (await path.getExternalStorageDirectory()).path;
    try {

      dio.download(song.href, '$dir/'+song.id);
      setState(() {
        downloading=true;
      });
    }
    catch(e){

    }
    setState(() {
      songPath='$dir/'+song.id;
      _player.setFilePath(songPath);
      downloading=false;
    });
  }

  void deleteFile(){
    final dir = Directory(songPath);
    print('h'+songPath);
    dir.delete(recursive: true);
  }

  @override
  void dispose() {
    deleteFile();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    StreamBuilder bar=StreamBuilder<Duration>(
      stream: _player.durationStream,
      builder: (context, snapshot) {
        final duration = snapshot.data ?? Duration.zero;
        return StreamBuilder<Duration>(
          stream: _player.getPositionStream(),
          builder: (context, snapshot) {
            var position = snapshot.data ?? Duration.zero;
            if (position > duration) {
              position = duration;
            }
            return SeekBar(
              duration: duration,
              position: position,
              onChangeEnd: (newPosition) {
                _player.seek(newPosition);
              },
            );
          },
        );
      },
    );
    StreamBuilder bar2=StreamBuilder<Duration>(
      stream: _player.durationStream,
      builder: (context, snapshot) {
        final duration = snapshot.data ?? Duration.zero;
        return StreamBuilder<Duration>(
          stream: _player.getPositionStream(),
          builder: (context, snapshot) {
            var position = snapshot.data ?? Duration.zero;
            if (position > duration) {
              position = duration;
            }
            return SeekBar2(
              duration: duration,
              position: position,
              onChangeEnd: (newPosition) {
                _player.seek(newPosition);
              },
            );
          },
        );
      },
    );
    StreamBuilder toolBar=StreamBuilder<FullAudioPlaybackState>(
      stream: _player.fullPlaybackStateStream,
      builder: (context, snapshot) {
        final fullState = snapshot.data;
        final state = fullState?.state;
        final buffering = fullState?.buffering;
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: deviceSize.width * 0.05),
              child: IconButton(
                icon: Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                ),
                iconSize: deviceSize.height * 0.04,
              ),
            ),
            SizedBox(
              width: deviceSize.width * 0.12,
            ),
            IconButton(
              icon: Icon(
                Icons.fast_rewind,
                color: Colors.white,
              ),
              iconSize: deviceSize.height * 0.05,
              onPressed: _player.play,
            ),
            if (downloading || state == AudioPlaybackState.connecting || buffering == true)
              Container(
                margin: EdgeInsets.all(8.0),
                height: deviceSize.height * 0.05,
                child: CircularProgressIndicator(),
              )
            else if (state == AudioPlaybackState.playing)
              IconButton(
                icon: Icon(
                  Icons.pause,
                  color: Colors.white,
                ),
                iconSize: deviceSize.height * 0.08,
                onPressed: _player.pause,
              )
            else
              IconButton(
                icon: Icon(
                  Icons.play_circle_filled,
                  color: Colors.white,
                ),
                iconSize: deviceSize.height * 0.08,
                onPressed: _player.play,
              ),
            IconButton(
              icon: Icon(
                Icons.fast_forward,
                color: Colors.white,
              ),
              iconSize: deviceSize.height * 0.05,
              onPressed: (){
                setState(() {
                  _player.stop();
                  deleteFile();
                  widget.trackNumber=widget.trackNumber+1;
                  init();
                  //this.dispose();
                });
              },
            ),
            SizedBox(
              width: deviceSize.width * 0.12,
            ),
            IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              iconSize: deviceSize.height * 0.03,
              onPressed: _player.play,
            ),
          ],
        );
      },
    );
    StreamBuilder playButton=StreamBuilder<FullAudioPlaybackState>(
      stream: _player.fullPlaybackStateStream,
      builder: (context, snapshot) {
        final fullState = snapshot.data;
        final state = fullState?.state;
        final buffering = fullState?.buffering;
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (downloading||state == AudioPlaybackState.connecting || buffering == true)
              Container(
                margin: EdgeInsets.all(8.0),
                height: deviceSize.height * 0.05,
                child: CircularProgressIndicator(),
              )
            else if (state == AudioPlaybackState.playing)
              IconButton(
                icon: Icon(
                  Icons.pause,
                  color: Colors.white,
                ),
                iconSize: deviceSize.height * 0.03,
                onPressed: _player.pause,
              )
            else
              IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
                iconSize: deviceSize.height * 0.03,
                onPressed: _player.play,
              ),
          ],
        );
      },
    );

    _panelHeightOpen = deviceSize.height * 1;
    _panelHeightClosed = deviceSize.height * 0.09;
    Widget _body() {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('Spotify Screen'),
        ),
      );
    }

    ///Sliding Up Panel Widget.
    return Scaffold(
      bottomNavigationBar:  BottomNavigation(
        currentTab: _currentTab,
        onSelectTab: _selectTab,
      ),
      body: SlidingUpPanel(
        controller: _pc,
        defaultPanelState: panelState,
        backdropTapClosesPanel: true,
        color: back, //Color.fromRGBO(0, 48, 24, 0.95),
        maxHeight: _panelHeightOpen,
        minHeight: _panelHeightClosed,
        body: pages[_currentTab.index],
        panel: Panel(
          song: song,
          pc: _pc,
          bar: bar,
          toolBar: toolBar,
        ),
        collapsed: Collapsed(song: song, playButton: playButton, bar:bar2),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        onPanelSlide: (double pos) => setState(
              () {
            _fabHeight =
                pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
          },
        ),
      ),
    );}
}



class TabNavigatorRoutes {
  static const String home = '/';
  static const String search = '/';
  static const String library = '/';
  static const String artist = '/';
  static const String premium = '/';
  static const String settings = '//settings';
  static const String premium2 = '//premium';
}