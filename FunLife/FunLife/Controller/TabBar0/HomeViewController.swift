//
//  HomeViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/15.
//

import UIKit
import Foundation
import AVFoundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class HomeViewController: UIViewController {
    
    let homeView = HomeView()                               // MARK: 把自定義UIView放進這頁
    var settingButtonItem = UIBarButtonItem()               // MARK: 建立一個UI NavBar 設定按鈕
    var addTaskButtonItem = UIBarButtonItem()               // MARK: 建立一個UI NavBar 加任務按鈕

    var timer: Timer?                                       // 方便後面用timer
    var counter = 0                                         // 計數器
    
    let soundID = SystemSoundID(kSystemSoundID_Vibrate)     // 震動
    
    // 5️⃣建立實體
    let addTaskVC = AddTaskViewController()                 // 把VC變數拉出來，讓後面可以 .點
    var documentID = ""                                     // myUserID格式是一個字串
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupHomeView()
        isUserDefault()
        
        // 使用 NotificationCenter 監聽裝置方向變化的通知 UIDevice.orientationDidChangeNotification，一旦收到該通知，就會調用 orientationChanged 方法
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationChanged),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
        // 6️⃣當作是自己
        addTaskVC.delegate = self
        print("函式執行後", UserDefaults.standard.dictionaryRepresentation())

        navbarAndtabbarsetup()
    }
    
    // MARK: 設定nav tab 底色與字顏色
    func navbarAndtabbarsetup() {
        // 設置 NavigationBar 的外觀
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        // 設置 TabBar 的外觀
//        tabBarController?.tabBar.backgroundImage = UIImage()
//        tabBarController?.tabBar.shadowImage = UIImage()
//        tabBarController?.tabBar.isTranslucent = true
        
        tabBarController?.tabBar.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
        tabBarController?.tabBar.barTintColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
        tabBarController?.tabBar.shadowImage = UIImage()
        tabBarController?.tabBar.isTranslucent = false
    }
        
    // MARK: 讓每次返回本頁會顯示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: 頁面出現後開啟Notification
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // MARK: 頁面要消失的時候關掉Notification
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // MARK: 建立UI NavBar +按鈕 與 設定按鈕
    func setupNavigation() {
//        settingButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
//                                            target: self,
//                                            action: #selector(navToSettingVC))
//        settingButtonItem.tintColor = UIColor.white
        
        addTaskButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                            target: self,
                                            action: #selector(navToAddTaskVC))
        addTaskButtonItem.tintColor = UIColor(red: 186/255, green: 129/255, blue: 71/255, alpha: 1) // UIColor.white
        
        // navigationItem.rightBarButtonItems = [settingButtonItem, addTaskButtonItem]    // 兩個按鈕
        navigationItem.rightBarButtonItems = [addTaskButtonItem]    // 兩個按鈕
    }
    
    // MARK: 跳轉頁 點擊Nav進入跳轉設定頁面VC
    @objc func navToSettingVC() {
        let settingVC = SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    // MARK: 跳轉頁 點擊Nav進入跳轉新增任務頁面VC
    @objc func navToAddTaskVC() {
        navigationController?.pushViewController(addTaskVC, animated: true)
    }

    // MARK: 把自定義的View設定邊界
    func setupHomeView() {
        view.addSubview(homeView)
        homeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            homeView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),    // view.safeAreaLayoutGuide.topAnchor
            homeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            homeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            homeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)   // view.safeAreaLayoutGuide.bottomAnchor
        ])
        
        homeView.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        // homeView.backgroundColor = UIColor(red: 160/255, green: 191/255, blue: 224/255, alpha: 1)
        homeView.circleTaskButton.addTarget(self, action: #selector(clickTaskBtn), for: .touchUpInside)
    }
    
    // MARK: 判斷這台手機是不是第一次下載我的app，如果是幫她建立一個myUserID，如果不是直接執行
    func isUserDefault () {
        if let isDocumentID = UserDefaults.standard.string(forKey: "myUserID") {
          print("有我建立的myUserID")
        } else {
            print("沒有我建立myUserID，所以我要建立一個")
            // createANewUserIDDocument()
            let firebaseManager = FirebaseManager()
            firebaseManager.createANewUserIDDocument()
        }
    }
    

            
    // MARK: 點擊任務按鈕會發生的事
    @objc func clickTaskBtn() {
        // 5️⃣ 當作是自己
        let sheetTaskVC = SheetTaskViewController()
        if let sheetPresentationController = sheetTaskVC.sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
            sheetPresentationController.preferredCornerRadius = 60
        }
        
        // 6️⃣
        sheetTaskVC.delegate = self
        present(sheetTaskVC, animated: true)
    }
    
    // MARK: 偵測目前翻面狀態
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
            print("現在是正面")
            stopTimer()
            alertMsg()
            
            // MARK: 更新firebase資料   counter: counter
            let firebaseManager = FirebaseManager()
            firebaseManager.modifyUser(counter: String(counter) ?? "nil",
                                       taskText: homeView.circleTaskButton.currentTitle ?? "nil"
            )
        case .faceDown:
            oriString = "FaceDown"
            print("現在是反面")
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
        homeView.label.text = oriString
    }
    
    // MARK: 停止計時
    func stopTimer() {
        // 停止計時器
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: 翻正面 提示框
    func alertMsg () {
        let alert = UIAlertController(title: "計時停止", message: "你翻面了，專注暫停", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
                                      style: .default,
                                      handler: { _ in NSLog("The \"OK\" alert occured.")}
                                     )
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: 開始計時
    func startTimer() {
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCircleTimerLabel), userInfo: nil, repeats: true)
        }
        print("timer是", timer)
        print("counter是", counter)
    }
    
    @objc func updateCircleTimerLabel() {
        
        if homeView.circleTimerLabel.text == "00.00.00" {
            counter = 0
            counter += 1
            let hours = counter / 3600
            let minutes = (counter % 3600) / 60
            let seconds = counter % 60
            let formattedTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            homeView.circleTimerLabel.text = formattedTime
            print("timer是", timer)
            print("counter是", counter)
        } else {
            counter += 1
            let hours = counter / 3600
            let minutes = (counter % 3600) / 60
            let seconds = counter % 60
            let formattedTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            homeView.circleTimerLabel.text = formattedTime
            print("timer是", timer)
            print("counter是", counter)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// 4️⃣遵從我們自定義的protocol
extension HomeViewController: AddTaskViewControllerDelegate {
    
    func passTask(parameter: String) {
        print("這是任務", parameter)
        homeView.circleTaskButton.setTitle(parameter, for: .normal)
    }
    
    func passTaskStartTime(parameter: String) {
        print("這是時間", parameter)
        homeView.circleTimerLabel.text = parameter
    }
}

// 4️⃣遵從我們自定義的protocol
extension HomeViewController: SheetTaskViewControllerDelegate {
    // 7️⃣ MARK: Delegate傳值
    func passValue(_ VC: SheetTaskViewController, parameter: String) {
        print("傳出來的String Task是", parameter)
        homeView.circleTaskButton.setTitle(parameter, for: .normal)
    }
    
    // 7️⃣ MARK: Delegate傳值
    func passValueTime(_ VC: SheetTaskViewController, parameterTime: String) {
        // print("傳出來的String Time是", parameterTime)
        // homeView.circleTimerLabel.text = parameterTime
        
        let hours = Int(parameterTime)! / 3600
        let minutes = (Int(parameterTime)! % 3600) / 60
        let seconds = Int(parameterTime)! % 60
        let formattedTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        homeView.circleTimerLabel.text = formattedTime
        counter = Int(parameterTime)!
    }
}
