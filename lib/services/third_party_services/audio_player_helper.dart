import 'dart:async';

import 'package:just_audio/just_audio.dart';

/// Abstract Class for providing audio player
abstract class AudioPlayerHelper {

  /// This method is used to initialize the Audio player
  /// Input : [url] for the network video to be player via Audio Player
  /// Output : [Future<bool>] this boolean future represents whether the player is initialized successfully or not
  Future<bool> setUrl({required String url});

  /// This method is used to listen to the playing stream of the audio player
  /// Output : [StreamSubscription<PlayerState>] it will be a Stream for the playing audio
  StreamSubscription<PlayerState> playerStateStream();

  /// This method is used to listen to the Position stream of the audio player
  /// Output : [StreamSubscription<Duration>] it will be a Stream for the realtime position on the audio seekbar
  StreamSubscription<Duration> positionStream();

  /// This method is used to listen to the Buffered Position stream of the audio player
  /// Output : [StreamSubscription<Duration>] it will be a Stream for the realtime Buffered position on the audio seekbar
  StreamSubscription<Duration> bufferedPositionStream();

  /// This method is used to listen to the Duration stream of the audio player
  /// Output : [StreamSubscription<Duration>] it will be a Stream for the realtime Duration of the audio seekbar
  StreamSubscription<Duration?> durationStream();

  /// This method is used to destroy the audio player instances from the memory
  void destroyAudioPlayer();

  /// This method will be responsible for Pausing the Audio
  Future<void> pauseAudio();

  /// This method will be responsible for Playing the Audio
  Future<void> playAudio();

  /// This method will be responsible for seeking the audio when dragged forward of reverse
  Future<void> seekAudio({required Duration position});
}

/// [AudioPlayerHelperImpl] implementation of [AudioPlayerHelper]
class AudioPlayerHelperImpl implements AudioPlayerHelper {
  final AudioPlayer audioPlayer;

  AudioPlayerHelperImpl(this.audioPlayer);

  @override
  Future<bool> setUrl({required String url}) async {
    try {
      await audioPlayer.setUrl(url);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  StreamSubscription<PlayerState> playerStateStream() {
    return audioPlayer.playerStateStream.listen((playerState) {});
  }

  @override
  StreamSubscription<Duration> positionStream() {
    return audioPlayer.positionStream.listen((position) {});
  }

  @override
  StreamSubscription<Duration> bufferedPositionStream() {
    return audioPlayer.bufferedPositionStream.listen((bufferedPosition) {});
  }

  @override
  StreamSubscription<Duration?> durationStream() {
    return audioPlayer.durationStream.listen((totalDuration) {});
  }

  @override
  void destroyAudioPlayer() {
    audioPlayer.dispose();
  }

  @override
  Future<void> pauseAudio() async {
    await audioPlayer.pause();
  }

  @override
  Future<void> playAudio() async {
    await audioPlayer.play();
  }

  @override
  Future<void> seekAudio({required Duration position}) async {
    await audioPlayer.seek(position);
  }
}
