//
//  TimerController.swift
//  HapticMetronome
//
//  Created by 齋藤修 on 2020/12/19.
//
//
//import Foundation
//
//class TimerController {
//
//    private var timer = Timer()
//
//    private var bpm: Double = 120.0
//    private var accuracy: Double = 0.002
//    private var numberOfTimeCell: Int {
//        Int(ceil(60.0 / (bpm * accuracy)))
//    }
//    private var timeInterval: TimeInterval {
//        TimeInterval(60.0 / (bpm * Double(numberOfTimeCell)))
//    }
//    private var count: Int = 0
//
//    private var hapticController = HapticMetronome()  // バイブレーションの管理を司る
//    private var soundController = SoundController()  // メトロノームの音の再生を司る
//
//
//    func prepare() {
//        // アプリ起動時に呼び出される関数
//        hapticController.engineStart()
//        soundController.prepare()
//    }
//
//    func start(mode: Int, bpm: Int) {
//        // メトロノーム開始時に呼び出される関数
//        self.timer.invalidate()
//        self.bpm = Double(bpm)  // テンポ設定
//        hapticController.mode = mode  // 振動モード設定
//        self.count = 0
//        self.timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true){
//            _ in
//            if self.count >= self.numberOfTimeCell {
//                self.soundController.play()  // メトロノームの音を鳴らす
//                self.hapticController.play()  // 短いバイブレーションを作動させる
//                self.count = 0
//            } else {
//                self.count += 1
//            }
//        }
//    }
//
//    func stop() {
//        // アプリがInactiveになった時に呼び出される関数
//        self.timer.invalidate()
//        hapticController.engineStop()
//        self.soundController.stop()
//    }
//}
