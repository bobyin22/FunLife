//
//  HomeViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/15.
//

import UIKit
import AVFoundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// 4️⃣ 遵從我們定義的protocol
class HomeViewController: UIViewController, SheetTaskViewControllerDelegate {
    
    let homeView = HomeView()

    // MARK: 建立一個UI NavBar 設定按鈕
    var settingSButton = UIBarButtonItem()
    
    // MARK: 建立一個UI NavBar 加任務按鈕
    var addButton = UIBarButtonItem()

    var counter = 0                                         // 計時
    var timer: Timer?                                       // 方便後面用timer
    let soundID = SystemSoundID(kSystemSoundID_Vibrate)     // 震動
    let db = Firestore.firestore()                          // 拉出來不用在每個函式宣告
    
    let addTaskVC = AddTaskViewController()                 // 把VC變數拉出來，讓後面可以 .點
    var documentID = ""                                     // myUserID格式是一個字串
    
    lazy var today = Date()
    lazy var dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
//        let year = dateComponents.year!
    lazy var month = dateComponents.month!
    lazy var day = dateComponents.day!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupHomeView()
        isUserDefault()
        view.backgroundColor = .systemGray
        homeView.circleTimerLabel.text = "\(counter)"
        homeView.circleTaskButton.addTarget(self, action: #selector(clickTaskBtn), for: .touchUpInside)   //
        
        // 使用 NotificationCenter 監聽裝置方向變化的通知 UIDevice.orientationDidChangeNotification。
        // 一旦收到該通知，就會調用 orientationChanged 方法
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationChanged),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)

    }
    
    // MARK: 讓每次返回本頁會顯示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeView.circleTaskButton.setTitle(addTaskVC.titleTaskLabel.text, for: .normal)   // MARK: 一登入沒有任務，添加任務後才會有任務
        homeView.circleTimerLabel.text = "0"
        counter = 0
    }
    
    // MARK: 建立UI NavBar +按鈕 與 設定按鈕
    func setupNavigation() {
        settingSButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(navToSettingVC))
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navToAddTaskVC))
        navigationItem.rightBarButtonItems = [settingSButton, addButton]    // 兩個按鈕
    }
    
    // MARK: 跳轉頁 點擊Nav進入跳轉設定頁面VC
    @objc func navToSettingVC() {
        let settingVC = SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    // MARK: 跳轉頁 點擊Nav進入跳轉新增任務頁面VC
    @objc func navToAddTaskVC() {
        let addTaskVC = AddTaskViewController()
        navigationController?.pushViewController(addTaskVC, animated: true)
    }

    
    // MARK: 把自定義的View設定邊界
    func setupHomeView() {
        view.addSubview(homeView)
        homeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            homeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            homeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            homeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            homeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
    
    // MARK: 判斷這台手機是不是第一次下載我的app，如果是幫她建立一個myUserID，如果不是直接執行
    func isUserDefault () {
        if let isDocumentID = UserDefaults.standard.string(forKey: "myUserID") {
          print("有我建立的myUserID")
        } else {
            print("沒有我建立myUserID，所以我要建立一個")
            createANewUserIDDocument()
        }
    }
    
    // MARK: firebase成功拿到創建的獨一無二的ID
    func createANewUserIDDocument() {
        //let task = ["timer": "0", "user": "包伯"]
        let newDocumentID = db.collection("users").document()   // firebase建立一個亂數DocumentID
        self.documentID = newDocumentID.documentID      // firebase建立一個亂數DocumentID 並賦值給變數
        UserDefaults.standard.set(self.documentID, forKey: "myUserID")      // 把亂數DocumentID 塞在 App的UserDefault裡
        
        // 建立firebase資料 ID 其他空
        db.collection("users").document("\(self.documentID)").setData(["name": ""]) { error in
            if let error = error {
                print("Document 建立失敗")
            } else {
                print("Document 建立成功")
            }
        }
        
    }
        
    // MARK: 每次翻轉後要更新秒數
    func modifyUser(counter: Int) {
        
//        let today = Date()
//
//        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
////        let year = dateComponents.year!
//        let month = dateComponents.month!
//        let day = dateComponents.day!
        
        // firebaseUserID = "\(UserDefaults.standard.string(forKey: "myUserID")!)"
        let documentReference = db.collection("users").document("\(UserDefaults.standard.string(forKey: "myUserID")!)").collection("\(month).\(day)").document(addTaskVC.titleTaskLabel.text ?? "沒接到")
        documentReference.getDocument { document, error in
            
            guard let document,
                  document.exists,
                  var user = try? document.data(as: Users.self)     // MARK: 這裡就有用到自定義的struct資料結構
            else {
                return
            }
            user.timer = "\(self.counter)"
            do {
                try documentReference.setData(from: user)
            } catch {
                print(error)
            }
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
    
    // MARK: 開始計時
    func startTimer() {
        // 開始計時器
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            //self.counter += 1
            //self.homeView.circleTimerLabel.text = "\(self?.counter ?? 0)"
            print("目前計時", self?.counter)
        }
    }

    // MARK: 停止計時
    func stopTimer() {
        // 停止計時器
        timer?.invalidate()
        timer = nil
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
            print("現在是正面", counter)
            stopTimer()
            alertMsg()
            // AudioServicesPlaySystemSound(soundID)
            // createUser(counter: counter)
            modifyUser(counter: counter)
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
        homeView.label.text = oriString
    }
    
    // MARK: 翻正面 提示框
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
    
    // 7️⃣ MARK: Delegate傳值
    func passValue(_ VC: SheetTaskViewController, parameter: String) {
        print("傳出來的String Task是", parameter)
        homeView.circleTaskButton.setTitle(parameter, for: .normal)
    }
    
    // 7️⃣ MARK: Delegate傳值
    func passValueTime(_ VC: SheetTaskViewController, parameterTime: String) {
        print("傳出來的String Time是", parameterTime)
        homeView.circleTimerLabel.text = parameterTime
    }
    
}
