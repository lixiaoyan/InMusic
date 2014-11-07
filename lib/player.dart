library player;

import "dart:async";
import "dart:html";
import "dart:web_audio";

class AudioPlayer {
  AudioElement _audioElement;
  AudioContext _audioContext;
  MediaElementAudioSourceNode _audioSource;

  Stream<Event> get onCanPlay => _audioElement.onCanPlay;
  Stream<Event> get onTimeUpdate => _audioElement.onTimeUpdate;
  Stream<Event> get onEnded => _audioElement.onEnded;
  Stream<Event> get onError => _audioElement.onError;

  bool get loop => _audioElement.loop;
  void set loop(bool value) { _audioElement.loop = value; }
  double get volume => _audioElement.volume;
    void set volume(double value) { _audioElement.volume = value; }
  double duration = 0.0;
  double currentTime = 0.0;
  bool isMuted = false;
  bool isPlaying = false;

  void load(String url, {bool autoplay: false}) {
    _audioElement.src = url;
    _audioElement.load();
    if(autoplay) {
      play();
    }
  }
  void play() {
    isPlaying = true;
    _audioElement.play();
  }
  void pause() {
    isPlaying = false;
    _audioElement.pause();
  }
  void seek(double time) {
    currentTime = time;
    _audioElement.currentTime = time;
  }
  void mute() {
    isMuted = true;
    _audioElement.muted = true;
  }
  void unmute() {
    isMuted = false;
    _audioElement.muted = false;
  }

  AudioPlayer() {
    _audioElement = new AudioElement();
    _audioContext = new AudioContext();
    _audioSource = _audioContext.createMediaElementSource(_audioElement);
    _audioSource.connectNode(_audioContext.destination);

    _audioElement.onCanPlay.listen((_) {
      duration = _audioElement.duration;
    });
    _audioElement.onTimeUpdate.listen((_) {
      currentTime = _audioElement.currentTime;
    });

    _audioElement.onEnded.listen((_) => pause());
    _audioElement.onError.listen((_) => pause());
  }
}
