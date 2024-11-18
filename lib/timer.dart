import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class countdownTimer extends StatefulWidget {
  const countdownTimer({super.key});

  @override
  State<countdownTimer> createState() => _countdownTimerState();
}

class _countdownTimerState extends State<countdownTimer> {
  int _remainingTime = 40;
  Timer? _timer;
  bool remain1 = false;
  bool remain2 = false;
  bool remain3 = false;
  bool remain4 = false;
  bool timeup = false;
  bool timerstart = false;

  late AudioPlayer player; // AudioPlayerインスタンスを定義

  @override
  void initState() {
    super.initState();
    player = AudioPlayer(); // インスタンスを初期化
  }

  Future<void> remainSound1() async {
    await player.setSource(AssetSource('sound1.mp3')); // 正しいファイルパスを指定
    await player.resume();
  }

  void timeupSound() {
    // タイムアップのサウンドを再生する処理を追加（必要なら）
  }

  void startTimer() {
    timerstart = true;
    _remainingTime = 40;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // デバッグ時は0を59にするとよい
        if (_remainingTime > 0) {
          _remainingTime--;
          if (_remainingTime < 32 && !remain1) {
            remain1 = true;
            remainSound1();
            debugPrint('8秒経ったよ');
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
    player.dispose(); // AudioPlayerのリソースを解放
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
                            const SizedBox(
                              width: 5,
                            ),
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
