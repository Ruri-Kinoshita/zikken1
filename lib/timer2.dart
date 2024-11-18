import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

////politeメッセージ

class CountdownTimer2 extends StatefulWidget {
  const CountdownTimer2({super.key});

  @override
  State<CountdownTimer2> createState() => _CountdownTimer2State();
}

class _CountdownTimer2State extends State<CountdownTimer2> {
  int _remainingTime = 35;
  Timer? _timer;
  bool remain1 = false;
  bool remain2 = false;
  bool remain3 = false;
  bool timeup = false;
  bool timerstart = false;

  late AudioPlayer player;
  final Random _random = Random();

  List<int> _availableSounds =
      List.generate(5, (index) => index + 1); // 使用可能な音声リスト

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
  }

  Future<void> playRandomSound() async {
    if (_availableSounds.isEmpty) {
      // リストが空なら再度初期化（全音声が一巡した場合）
      _availableSounds = List.generate(5, (index) => index + 1);
    }

    int randomIndex = _random.nextInt(_availableSounds.length);
    int soundIndex = _availableSounds[randomIndex]; // ランダムにインデックスを取得
    _availableSounds.removeAt(randomIndex); // 使用済み音声をリストから削除

    String fileName = 'p$soundIndex.mp3';
    await player.setSource(AssetSource(fileName));
    await player.resume();

    DateTime now = DateTime.now(); // 現在の時間を取得
    String formattedTime =
        '${now.hour}:${now.minute}:${now.second}'; // 時間をフォーマット
    debugPrint('$fileName が再生されました（再生時間: $formattedTime）');
    debugPrint('残りの使用可能な音声: $_availableSounds');
  }

  void timeupSound() {
    // タイムアップのサウンドを再生する処理を追加（必要なら）
  }

  void startTimer() {
    timerstart = true;
    _remainingTime = 35;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
          if (_remainingTime < 30 && !remain1) {
            remain1 = true;
            playRandomSound();
            debugPrint('5秒経ったよ');
          } else if (_remainingTime < 20 && !remain2) {
            remain2 = true;
            playRandomSound();
            debugPrint('15秒経ったよ');
          } else if (_remainingTime < 10 && !remain3) {
            remain3 = true;
            playRandomSound();
            debugPrint('25秒経ったよ');
          }
        } else {
          timeup = true;
          timeupSound();
          debugPrint('タイマー止まったよ');
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('タイマー')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              timeup
                  ? const Text(
                      'タイムアップ！',
                      style: TextStyle(fontSize: 100),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('残り時間', style: TextStyle(fontSize: 64)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 64),
                            Text(
                              '$_remainingTime',
                              style: const TextStyle(fontSize: 210),
                            ),
                            const SizedBox(width: 5),
                            const Column(
                              children: [
                                SizedBox(
                                  height: 100,
                                ),
                                Text('秒', style: TextStyle(fontSize: 64)),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: timerstart ? null : startTimer,
                child: const Text('タイマー開始'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
