import 'package:flutter/material.dart';


class AudioModel with ChangeNotifier {


  bool _playing = false;
  Duration _songDuration = new Duration(milliseconds: 0);
  Duration _current = new Duration(milliseconds: 0);
  String get songTotalDuration => this.printDuration(this._songDuration);
  String get currentSecond => this.printDuration(this._current);
  double get porcentaje => (this._songDuration.inSeconds > 0) ? this._current.inSeconds / this._songDuration.inSeconds : 0;



 bool get playing => this._playing;

  set playing(bool value) {
    this._playing = value;
    notifyListeners();
  }


  Duration get songDuration => this._songDuration;
  Duration get current => this._current;


  set  songDuration(Duration value) {
    this._songDuration = value;
    notifyListeners();
  }
  set current(Duration value) {
    this._current = value;
        notifyListeners();

  }


  AnimationController _controller;
  get controller => this._controller;
  set controller(AnimationController value) {
    this._controller = value;
  }

  String printDuration(Duration duration) {

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "$twoDigitMinutes:$twoDigitSeconds";

  }


}