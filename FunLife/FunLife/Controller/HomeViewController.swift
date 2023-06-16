//
//  HomeViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/15.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {          //: BaseViewController

    let circleView = UIView()           // 圓形View
    let circleTimerLabel = UILabel()    // 計時時間Label
    let circleDateLabel = UILabel()    // 計時日期Label
    let circleTaskLabel = UILabel()    // 任務Label
    var settingSButton = UIBarButtonItem()
    var addButton = UIBarButtonItem()
    
    var label: UILabel! // 測試
    var counter = 0
    var timer: Timer?
    let soundID = SystemSoundID(kSystemSoundID_Vibrate)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        setupNavigation()
        setupCircleUI()
        setupDate()
        setupTimer()
        setupTask()
        setupFlipLabel()
        
    }
    
    func startTimer() {
        // 開始計時器
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.counter += 1
            self?.circleTimerLabel.text = "\(self?.counter ?? 0)"
        }
    }

    func stopTimer() {
        // 停止計時器
        timer?.invalidate()
        timer = nil
    }
        
    func setupFlipLabel() {
        label = UILabel(frame: CGRect(x: 140, y: 450, width: 200, height: 50))
        // label.center = view.center
        // label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(label)
        
        // 使用 NotificationCenter 監聽裝置方向變化的通知 UIDevice.orientationDidChangeNotification。
        // 一旦收到該通知，就會調用 orientationChanged 方法
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationChanged),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }
    
    @objc func orientationChanged() {
        // orientationChanged 方法中，獲取當前裝置的方向 orientation
        let orientation = UIDevice.current.orientation
        
        // 目前沒有字
        var oriString: String = ""
        
        switch orientation {
        case .landscapeLeft:
            oriString = "LandscapeLeft"
            stopTimer()
        case .landscapeRight:
            oriString = "LandscapeRight"
            stopTimer()
        case .faceUp:
            oriString = "FaceUp"
            print("現在是正面", counter)
            stopTimer()
            alertMsg()
            AudioServicesPlaySystemSound(soundID)
        case .faceDown:
            oriString = "FaceDown"
            print("現在是反面", counter)
            startTimer()
            AudioServicesPlaySystemSound(soundID)
        case .portrait:
            oriString = "Portrait"
            stopTimer()
        case .portraitUpsideDown:
            oriString = "PortraitUpsideDown"
            stopTimer()
        default:
            oriString = "Unknown"
            stopTimer()
        }
        label.text = oriString
    }
    
    // 提示框
    func alertMsg () {
        let alert = UIAlertController(title: "計時停止", message: "你翻面了，專注暫停", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
                                      style: .default,
                                      handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 建立 NavBar +按鈕 與 設定按鈕
    func setupNavigation() {
        settingSButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(navToSettingVC))
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navToAddTaskVC))
        navigationItem.rightBarButtonItems = [settingSButton, addButton]    // 兩個按鈕
    }
    
    // 點擊Nav進入跳轉設定頁面VC
    @objc func navToSettingVC() {
        let settingVC = SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    // 點擊Nav進入跳轉新增任務頁面VC
    @objc func navToAddTaskVC() {
        let addTaskVC = AddTaskViewController()
        navigationController?.pushViewController(addTaskVC, animated: true)
    }
    
    // 建立圓形View
    func setupCircleUI() {
        view.addSubview(circleView)
        circleView.backgroundColor = .systemYellow
        circleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -200),
            circleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -150),
            circleView.heightAnchor.constraint(equalToConstant: 300),
            circleView.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        circleView.layer.borderColor = UIColor.black.cgColor
        circleView.layer.borderWidth = 2.0

        // 圓半徑設為 寬的一半
        circleView.layer.cornerRadius = 150
        // 確保圓形圖不顯示超出邊界的部分
        circleView.clipsToBounds = true
        circleView.layer.masksToBounds = false
    }
    
    // 建立日期Label
    func setupDate() {
        view.addSubview(circleDateLabel)
        circleDateLabel.text = "2023.06.13.Tue"
        circleDateLabel.font = UIFont(name: "Helvetica", size: 20)
        circleDateLabel.backgroundColor = .systemRed
        circleDateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleDateLabel.topAnchor.constraint(equalTo: circleView.topAnchor, constant: 70),
            circleDateLabel.leadingAnchor.constraint(equalTo: circleView.centerXAnchor, constant: -70)
        ])
    }
    
    // 建立倒數計時器Label
    func setupTimer() {
        view.addSubview(circleTimerLabel)
        circleTimerLabel.text = "\(counter)"
        circleTimerLabel.font = UIFont(name: "Helvetica", size: 50)
        circleTimerLabel.backgroundColor = .systemRed
        circleTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleTimerLabel.topAnchor.constraint(equalTo: circleDateLabel.bottomAnchor, constant: 10),
            circleTimerLabel.leadingAnchor.constraint(equalTo: circleView.centerXAnchor, constant: -18)
        ])
    }
    
    // 建立任務Label
    func setupTask() {
        view.addSubview(circleTaskLabel)
        circleTaskLabel.text = "線性代數"
        circleTaskLabel.font = UIFont(name: "Helvetica", size: 20)
        circleTaskLabel.backgroundColor = .systemRed
        circleTaskLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleTaskLabel.topAnchor.constraint(equalTo: circleTimerLabel.bottomAnchor, constant: 20),
            circleTaskLabel.leadingAnchor.constraint(equalTo: circleTimerLabel.centerXAnchor, constant: -40)
        ])
    }
}
