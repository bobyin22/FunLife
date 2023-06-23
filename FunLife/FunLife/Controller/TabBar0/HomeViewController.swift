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
    //: BaseViewController    原本有用base目前沒用
    
    // 5️⃣建立實體
    // var sheetTaskVC: SheetTaskViewController?
    
    // var structArray = [Users]()             // 目前沒用到

    let circleView = UIView()               // UI圓形View
    let circleTimerLabel = UILabel()        // UI計時時間Label
    let circleDateLabel = UILabel()         // UI計時日期Label
    let circleTaskButton = UIButton()         // UI任務Label
    var settingSButton = UIBarButtonItem()  // UI設定  按鈕
    var addButton = UIBarButtonItem()       // UI加任務 按鈕
    
    var label: UILabel!                     // UI測試Label
    var counter = 0                         // 計時
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
        
        print("函式執行前", UserDefaults.standard.dictionaryRepresentation())
        isUserDefault()
        
        view.backgroundColor = .systemGray
        setupNavigation()
        setupCircleUI()
        setupDate()
        setupTimer()
        setupTask()
        setupFlipLabel()
        
       
        // UserDefaults.standard.removeObject(forKey: "myUserID")
        
        print("函式執行後", UserDefaults.standard.dictionaryRepresentation())
    }
    
    // MARK: 讓每次返回本頁會顯示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        circleTaskButton.setTitle(addTaskVC.titleTaskLabel.text, for: .normal)   // MARK: 一登入沒有任務，添加任務後才會有任務
        circleTimerLabel.text = "0"
        counter = 0
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
        let task = ["timer": "0", "user": "包伯"]
        let newDocumentID = db.collection("users").document()   // firebase建立一個亂數DocumentID
        self.documentID = newDocumentID.documentID      // firebase建立一個亂數DocumentID 並賦值給變數
        UserDefaults.standard.set(self.documentID, forKey: "myUserID")      // 把亂數DocumentID 塞在 App的UserDefault裡
        
        db.collection("users").document("\(self.documentID)").setData([:]) { error in
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
        
        // navigationController?.pushViewController(settingVC, animated: true)
        present(sheetTaskVC, animated: true)
    }
    
    // MARK: 開始計時
    func startTimer() {
        // 開始計時器
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.counter += 1
            self?.circleTimerLabel.text = "\(self?.counter ?? 0)"
            print("目前計時", self?.counter)
        }
    }

    // MARK: 停止計時
    func stopTimer() {
        // 停止計時器
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: 建立UI 顯示目前在哪一面的Label
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
        label.text = oriString
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
        // let addTaskVC = AddTaskViewController()
        navigationController?.pushViewController(addTaskVC, animated: true)
    }
    
    // MARK: UI建立圓形View
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
    
    // MARK: UI建立日期Label
    func setupDate() {
        view.addSubview(circleDateLabel)
        circleDateLabel.font = UIFont(name: "Helvetica", size: 20)
        circleDateLabel.backgroundColor = .systemRed
        circleDateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleDateLabel.topAnchor.constraint(equalTo: circleView.topAnchor, constant: 70),
            circleDateLabel.leadingAnchor.constraint(equalTo: circleView.centerXAnchor, constant: -80)
        ])
        
        let today = Date()
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
        let year = dateComponents.year!
        let month = dateComponents.month!
        let day = dateComponents.day!
        let weekday = Calendar.current.component(.weekday, from: today)
        let weekdayString = Calendar.current.weekdaySymbols[weekday - 1]
        circleDateLabel.text = "\(year).\(month).\(day).\(weekdayString)" // "2023.06.13.Tue"
    }
    
    // MARK: UI建立倒數計時器Label
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
    
    // MARK: UI建立任務Label
    func setupTask() {
        view.addSubview(circleTaskButton)
        circleTaskButton.setTitle("線性代數", for: .normal)
        circleTaskButton.backgroundColor = .systemGreen
        circleTaskButton.setTitleColor(UIColor.black, for: .normal)
        circleTaskButton.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        circleTaskButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleTaskButton.topAnchor.constraint(equalTo: circleTimerLabel.bottomAnchor, constant: 20),
            circleTaskButton.leadingAnchor.constraint(equalTo: circleTimerLabel.centerXAnchor, constant: -40)
        ])
        
        circleTaskButton.addTarget(self, action: #selector(clickTaskBtn), for: .touchUpInside)   //
    }
    
    // 7️⃣ MARK: Delegate傳值
    func passValue(_ VC: SheetTaskViewController, parameter: String) {
        print("傳出來的String Task是", parameter)
        circleTaskButton.setTitle(parameter, for: .normal)
    }
    
    // 7️⃣ MARK: Delegate傳值
    func passValueTime(_ VC: SheetTaskViewController, parameterTime: String) {
        print("傳出來的String Time是", parameterTime)
        circleTimerLabel.text = parameterTime
    }
    
}
