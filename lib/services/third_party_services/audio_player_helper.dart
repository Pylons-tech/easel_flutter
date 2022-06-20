import 'dart:async';

import 'package:just_audio/just_audio.dart';

/// Abstract Class for providing audio player
abstract class AudioPlayerHelper {
  ///This method works as an intializer for Audio Player,
  ///It will allow us to pass the url for the Audio
  ///Returns true if Url is loaded otherwise false
  Future<bool> setFile({required String file});

  ///This method works as an initializer for Audio Player,
  ///It will take file path as input
  ///It will load the specific file for further operations like [Play], [Pause], [Resume]
  Future<void> setAudioSource({required AudioSource file});

  /// This method will be a listener to the playerStateStream
  /// which will listen the audio stream being player
  Stream<PlayerState> playerStateStream();

  /// This method will be a listener to the positionStream which
  /// will listen to the current DurationPosition of the audio track
  Stream<Duration> positionStream();

  /// This method will be a listener to the bufferedPositionStream which
  /// will listen to the duration position where the audio is being buffered
  Stream<Duration> bufferedPositionStream();

  /// This method will be a listener to the durationStream which
  /// will listen to the DurationStream being player
  Stream<Duration?> durationStream();

  /// This method will be responsible for destroying the audio player instances from the memory
  void destroyAudioPlayer();

  /// This method will be responsible for Pausing the Audio
  Future<void> pauseAudio();

  /// This method will be responsible for Playing the Audio
  Future<void> playAudio();

  /// This method will be responsible for seeking the audio when dragged forward of reverse
  /// It will take [Position] of the audio
  /// This method will seek the audio to specific [Position] given in parameters
  Future<void> seekAudio({required Duration position});
}

/// [AudioPlayerHelperImpl] implementation of [AudioPlayerHelper]
class AudioPlayerHelperImpl implements AudioPlayerHelper {
  final AudioPlayer audioPlayer;

  AudioPlayerHelperImpl(this.audioPlayer);

  @override
  Future<bool> setFile({required String file}) async {
    try {
      await audioPlayer.setFilePath(file);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<PlayerState> playerStateStream() {
    return audioPlayer.playerStateStream;
  }

  @override
  Stream<Duration> positionStream() {
    return audioPlayer.positionStream;
  }

  @override
  Stream<Duration> bufferedPositionStream() {
    return audioPlayer.bufferedPositionStream;
  }

  @override
  Stream<Duration?> durationStream() {
    return audioPlayer.durationStream;
  }

  @override
  void destroyAudioPlayer() {
    audioPlayer.stop();
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

  @override
  Future<void> setAudioSource({required AudioSource file}) async {
    await audioPlayer.setAudioSource(file, preload: true);
    await audioPlayer.load();
  }
}
