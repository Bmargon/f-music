import 'package:flutter/material.dart';
import 'package:music/src/models/audio_player_model.dart';
import 'package:music/src/pages/music_player_page.dart';
import 'package:music/src/theme/theme.dart';
import 'package:provider/provider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => new AudioModel()),
      ],
          child: MaterialApp(
        theme: miTema,
        title: 'Material App',
        home: Scaffold(
          body: Center(
            child: MusicPlayerPage()
          ),
        ),
      ),
    );
  }
}