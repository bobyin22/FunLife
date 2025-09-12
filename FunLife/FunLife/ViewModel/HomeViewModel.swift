//
//  HomeViewModel.swift
//  FunLife
//
//  Created by Bob Yin on 9/8/25.
//

import UIKit
import Combine
import AVFoundation

struct AlertContent {
    let title: String
    let message: String
}

class HomeViewModel: ObservableObject {

    private let firebaseService: FirebaseServiceProtocol

    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
        checkUserDefaults()
    }

    @Published var counter: Int = 0
    @Published var formattedTime: String = "00:00:00"
    @Published var currentOrientation: String = "Unknown"
    @Published var shouldVibrate: Bool = false
    @Published var shouldShowAlert: Bool = false
    @Published var currentTaskText: String = ""
    @Published var shouldPlayMusic: Bool = false
    private let player = AVPlayer()
    @Published var alertContent: AlertContent?
    @Published var shouldNavigateToAddTask: Bool = false

    var timer: Timer?

    // MARK: 停止計時
    func stopTimer() {
        // 停止計時器
        timer?.invalidate()
        timer = nil
    }

    // MARK: 開始計時
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                self.counter += 1
                self.formattedTime = self.formatTime(self.counter)
            })
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, secs)
    }

    func handleOrientationChange(_ orientation: UIDeviceOrientation) {
          switch orientation {
          case .landscapeLeft:
              currentOrientation = "LandscapeLeft"
              stopTimer()
          case .landscapeRight:
              currentOrientation = "LandscapeRight"
              stopTimer()
          case .faceUp:
              currentOrientation = "FaceUp"
              stopTimer()
              alertContent = AlertContent(title: "計時停止", message:
                "你翻面了，專注暫停")
              shouldShowAlert = true
              firebaseService.modifyUser(counter: String(counter), taskText: currentTaskText)
          case .faceDown:
              currentOrientation = "FaceDown"
              startTimer()
              shouldVibrate = true
          case .portrait:
              currentOrientation = "Portrait"
              stopTimer()
          case .portraitUpsideDown:
              currentOrientation = "PortraitUpsideDown"
              stopTimer()
          default:
              currentOrientation = "Unknown"
              stopTimer()
          }
      }

    func playMusic() {
        let url = Bundle.main.url(forResource: "sound7", withExtension: "mp3")!
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }

    // MARK: 判斷這台手機是不是第一次下載我的app，如果是幫她建立一個myUserID，如果不是直接執行
    func checkUserDefaults () {
        if let isDocumentID = UserDefaults.standard.string(forKey: "myUserID") {
          print("有我建立的myUserID")
        } else {
            print("沒有我建立myUserID，所以我要建立一個")
            firebaseService.createANewUserIDDocument()
        }
    }

    func triggerAddTaskNavigation() {
        shouldNavigateToAddTask = true
    }
}
