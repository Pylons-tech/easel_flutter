import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// Abstract Class for providing audio player
abstract class AudioPlayerHelper {
  ///This method works as an intializer for Audio Player,
  ///Input: [String] as path of audio
  ///Output: [bool] tells weather the audio is set or not
  Future<bool> setFile({required String file});

  ///This method works as an initializer for Audio Player,
  ///Input: [File] file of selected audio
  Future<void> setAudioSource({required File file});

  /// This method will be a listener to the playerStateStream
  /// Output: [Stream] of [PlayerState] data returned
  Stream<PlayerState> playerStateStream();

  /// This method will be a listener to the positionStream
  /// Output: [Stream] of [Duration] of Position Stream returned
  Stream<Duration> positionStream();

  /// This method will be a listener to the bufferedPositionStream
  /// Output: [Stream] of [Duration] of Buffered Position Stream
  Stream<Duration> bufferedPositionStream();

  /// This method will be a listener to the durationStream which
  /// Output: [Stream] of [Duration] of current audio returned
  Stream<Duration?> durationStream();

  /// This method will be responsible for destroying the audio player instances from the memory
  /// This method is used to initialize the Audio player
  /// Input : [url] for the network video to be player via Audio Player
  /// Output : [bool] this represents whether the player is initialized successfully or not
  Future<bool> setUrl({required String url});

  /// This method is used to listen to the playing stream of the audio player
  /// Output : [Duration] it will be a Stream for the playing audio
  Stream<PlayerState> playerStateStream();

  /// This method is used to listen to the Position stream of the audio player
  /// Output : [Duration] it will be a Stream for the realtime position on the audio seekbar
  Stream<Duration> positionStream();

  /// This method is used to listen to the Buffered Position stream of the audio player
  /// Output : [Duration] it will be a Stream for the realtime Buffered position on the audio seekbar
  Stream<Duration> bufferedPositionStream();

  /// This method is used to listen to the Duration stream of the audio player
  /// Output : [Duration] it will be a Stream for the realtime Duration of the audio seekbar
  Stream<Duration?> durationStream();

  /// This method is used to destroy the audio player instances from the memory
  void destroyAudioPlayer();

  /// This method will be responsible for Pausing the Audio
  Future<void> pauseAudio();

  /// This method will be responsible for Playing the Audio
  Future<void> playAudio();

  /// This method will be responsible for seeking the audio when dragged forward of reverse
  /// Input: [Duration] to seek the audio to specific [Position]
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
      await audioPlayer.load();
  Future<bool> setUrl({required String url}) async {
    try {
      await audioPlayer.setUrl(url);
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
    audioPlayer.seek(Duration.zero);

    if(audioPlayer.playing){
      audioPlayer.pause();


    }

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
  Future<void> setAudioSource({required File file}) async {
    await audioPlayer.setFilePath(file.path, preload: false);
    await audioPlayer.load();
  }
}
