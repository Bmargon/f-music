import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music/src/helpers/helpers.dart';
import 'package:music/src/models/audio_player_model.dart';
import 'package:music/src/widgets/appbar.dart';
import 'package:provider/provider.dart';


class MusicPlayerPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Background(),
            Column(
              children: <Widget>[
                CustomAppBar(),
                ImagenDiscoyDuracino(),
                TituloPlay(),
                Expanded(
                  child: Lyrics()
                )
              ],
            ),
          ],
        )
     ),
   );
  }
}

class Background extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.8,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.center,
          colors: [
            Color(0xff33333e),
            Color(0xff201e28),
          ]
        )
      ),
    );
  }
}

class Lyrics extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final lyrics = getLyrics();
    return Container(
      margin: EdgeInsets.only(top: 65),
      child: ListWheelScrollView(
        itemExtent: 42, 
        diameterRatio: 1.5,
        physics: BouncingScrollPhysics(),
        children: lyrics.map(
          (linea) => Text(linea, style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(0.5)))
        ).toList())
    );
  }
}

class TituloPlay extends StatefulWidget {

  @override
  _TituloPlayState createState() => _TituloPlayState();
}

class _TituloPlayState extends State<TituloPlay> with SingleTickerProviderStateMixin{
  bool isPLaying = false;
  AnimationController animation;
  bool firstTime = true;
  final assetAudioPlayer = new AssetsAudioPlayer();

  @override
  void initState() {

    animation = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    super.initState();
  }
  @override
  void dispose() {
    this.animation.dispose();
    super.dispose();
  }


  void open() {
    final audioPlayerModel = Provider.of<AudioModel>(context, listen: false);
    assetAudioPlayer.open(Audio('assets/Breaking-Benjamin-Far-Away.mp3'));
    assetAudioPlayer.currentPosition.listen((duration) {
      audioPlayerModel.current = duration;
    });
    assetAudioPlayer.current.listen((playingAudio) {
      audioPlayerModel.songDuration = playingAudio.audio.duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(top: 40),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text('Far Away', style: TextStyle(fontSize: 30, color: Colors.white.withOpacity(0.8))),
              Text('Breaking Benjamin', style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.5))),
            ],
          ),
          Spacer(),
          FloatingActionButton(
            backgroundColor: Color(0xffF8CB51),
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause, 
              progress: animation
            ),
            onPressed: () {
              final provider = Provider.of<AudioModel>(context, listen: false);
              if (this.isPLaying) {
                animation.reverse();
                this.isPLaying = false;
                provider.controller.stop();
              } else {  
                animation.forward();
                this.isPLaying = true;
                provider.controller.repeat();
              }
              if (firstTime) {
                this.open();
                this.firstTime = false;
              } else { 
                assetAudioPlayer.playOrPause();
              }
            },
          )
        ],
      ),
    );
  }
}

class ImagenDiscoyDuracino extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.only(top: 70),
      child: Row(
        children: <Widget>[
          ImagenDisco(),
          SizedBox(width: 40),
          Progreso()
        ],
      ),
    );
  }
}

class Progreso extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioModel>(context);
    final porcentaje = audioPlayerModel.porcentaje;
    return Container(
      child: Column(
        children: <Widget>[
          Text('${audioPlayerModel.songTotalDuration}', style: TextStyle(color: Colors.white.withOpacity(0.4)),),
          SizedBox(height: 10,),
          Stack(
            children: <Widget>[
              Container(
                width: 3,
                height: 230 ,
                color: Colors.white.withOpacity(0.1),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 3,
                  height: 230 * porcentaje,
                  color: Colors.white.withOpacity(0.8),
                ),
              )
            ],
          ),
          SizedBox(height: 10,),
          Text('${audioPlayerModel.currentSecond}', style: TextStyle(color: Colors.white.withOpacity(0.4)),)
        ],
      ),
    );
  }
}

class ImagenDisco extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AudioModel>(context);
    return Container(
      padding: EdgeInsets.all(20),
      width: 250,
      height: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SpinPerfect(
              manualTrigger: true,
              controller: (animationController) => controller.controller = animationController,
              duration: Duration(seconds: 10),
              infinite: true,
              child: Image(image: AssetImage('assets/aurora.jpg'))),
            Container(
              width: 25, 
              height: 25,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: 
                BorderRadius.circular(100)
              ),
            ),
            Container(
              width: 18, 
              height: 18,
              decoration: BoxDecoration(
                color: Color(0xff1c1c25),
                borderRadius: 
                BorderRadius.circular(100)
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Color(0xff484750),
            Color(0xff1e1c24),
          ])
      ),
    );
  }
}