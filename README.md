# HapticMetronome-iOS
<a href="https://developer.apple.com/documentation/corehaptics">Core Haptics</a>を利用した触覚フィードバックメトロノームiOSアプリ

### App Storeでリリース中

<a href="https://apps.apple.com/jp/app/haptic-metronome/id1565909516"><img src="https://user-images.githubusercontent.com/73047429/117178351-e6cd8000-ae0c-11eb-92f2-a5e51b7908ee.png" alt="[Badge]" width="180px"><a/>

App Storeで当アプリを無料で配信しています。対応機種はiPhone 8以降になります。iOS 14.1以上対応です。

<img width="713" alt="スクリーンショット 2021-05-18 22 21 56" src="https://user-images.githubusercontent.com/73047429/118659457-4b82d480-b828-11eb-8b5b-99af68121e6b.png">

## 搭載機能
- BPMが12~280で設定可能
- 音に合わせてiPhoneが振動する
- 振動の種類は3種類(クリック、バイブレーション(短)、バイブレーション(長))
- 強拍に対応: 2~8拍に1回、音色を変化せさる
- 連符の刻みに対応: 1拍の中に刻みとして2~4連符を鳴らすことが可能
- "+"ボタン、"-"ボタンは長押し対応
- BPMを半分/2倍にする、"÷2"ボタン/"×2"ボタンを採用
- リズムに合わせて変化する簡単なアニメーションも実装

## 主要なファイル

- `HapticMetronome-iOS/HapticMetronome/HapticMetronome/ContentView.swift`

View層。ContentView構造体および各種列挙型を記述。Viewの描画に必要な情報と下記Controllerのインスタンスを保持する。

- `HapticMetronome-iOS/HapticMetronome/HapticMetronome/HapticMetronome.swift`

Controller層。HapticMetronomeクラスを記述。音源の再生、振動の制御、アニメーション描画のための時間取得などをCore Hapticsフレームワークを通して一括管理する。
