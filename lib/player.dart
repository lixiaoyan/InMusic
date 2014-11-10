library player;

import "dart:async";
import "dart:html";
import "dart:web_audio";

class AudioPlayer {
  static const double fadeTime = 0.8;
  static const Duration fadeDuration = const Duration(milliseconds: 800);

  AudioElement _audioElement;
  AudioContext _audioContext;
  MediaElementAudioSourceNode _audioSource;
  GainNode _gainNode;

  Timer _fadeTimer = null;

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
    duration = 0.0;
    currentTime = 0.0;
    _audioElement.src = url;
    _audioElement.load();
    if(autoplay) {
      play();
    }
  }
  void play() {
    if(_fadeTimer != null) {
      _fadeTimer.cancel();
      _fadeTimer = null;
    }
    isPlaying = true;
    _audioElement.play();
    _gainNode.gain.linearRampToValueAtTime(1.0, _audioContext.currentTime + fadeTime);
  }
  void pause() {
    isPlaying = false;
    _gainNode.gain.linearRampToValueAtTime(0.0, _audioContext.currentTime + fadeTime);
    _fadeTimer = new Timer(fadeDuration, () => _audioElement.pause());
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
    _gainNode = _audioContext.createGain();
    _audioSource.connectNode(_gainNode);
    _gainNode.connectNode(_audioContext.destination);

    _gainNode.gain.value = 0.0;

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
