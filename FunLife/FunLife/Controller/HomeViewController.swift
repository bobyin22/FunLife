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

class HomeViewController: UIViewController {          //: BaseViewController
    var structArray = [Users]()

    let circleView = UIView()               // 圓形View
    let circleTimerLabel = UILabel()        // 計時時間Label
    let circleDateLabel = UILabel()         // 計時日期Label
    let circleTaskLabel = UILabel()         // 任務Label
    var settingSButton = UIBarButtonItem()  // 設定  按鈕
    var addButton = UIBarButtonItem()       // 加任務 按鈕
    
    var label: UILabel!                     // 測試Label
    var counter = 0                         // 計時
    var timer: Timer?                                       // 方便後面用timer
    let soundID = SystemSoundID(kSystemSoundID_Vibrate)     // 聲音
    let db = Firestore.firestore()                          // 拉出來不用在每個函式宣告
    
    let addTaskVC = AddTaskViewController()                 // 把VC變數拉出來，讓後面可以 .點
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        setupNavigation()
        setupCircleUI()
        setupDate()
        setupTimer()
        setupTask()
        setupFlipLabel()
        
//        createUser()
//        fetchAPI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        circleTaskLabel.text = addTaskVC.titleTaskLabel.text // 每次切回主畫面，會抓到剛剛輸入的新任務
        circleTimerLabel.text = "0"
        counter = 0
    }
    
    func modifyUser(counter: Int) {
        
        let today = Date()

        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
        let year = dateComponents.year!
        let month = dateComponents.month!
        let day = dateComponents.day!

        let weekday = Calendar.current.component(.weekday, from: today)
        let weekdayString = Calendar.current.weekdaySymbols[weekday - 1]
        
        let documentReference = db.collection("users").document("Bob").collection("\(month).\(day)").document(addTaskVC.titleTaskLabel.text ?? "沒接到")
        documentReference.getDocument { document, error in
            
            // "\(month).\(day)"
            // addTaskVC.titleTaskLabel.text
            guard let document,
                  document.exists,
                  var user = try? document.data(as: Users.self)
            else {
                print("XXX")
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
    
    func createUser(counter: Int) {
        let user = Users(user: "bob", timer: "\(counter)")
        // Users(timer: "\(counter)", user: "bob")
        do {
            let documentReference = try db.collection("users").addDocument(from: user)
            print("1", documentReference.documentID)
        } catch {
            print(error)
        }
    }
    
    func fetchAPI() {
        // 抓取firebase的資料並顯示在畫面上
        db.collection("users").getDocuments { snapshot, error in
            guard let snapshot else { return }
            print("snapshot", snapshot)
            // 把所有資料傳給變數
            let users = snapshot.documents.compactMap { snapshot in try? snapshot.data(as: Users.self)
            }
            
            print("api資料是", users)
            print("api資料數量", users.count)
        }
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
    
    // MARK: 顯示目前翻面的Label
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
    
    // MARK: 提示框
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
    
    // MARK: 建立 NavBar +按鈕 與 設定按鈕
    func setupNavigation() {
        settingSButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(navToSettingVC))
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navToAddTaskVC))
        navigationItem.rightBarButtonItems = [settingSButton, addButton]    // 兩個按鈕
    }
    
    // MARK: 點擊Nav進入跳轉設定頁面VC
    @objc func navToSettingVC() {
        let settingVC = SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    // MARK: 點擊Nav進入跳轉新增任務頁面VC
    @objc func navToAddTaskVC() {
        // let addTaskVC = AddTaskViewController()
        navigationController?.pushViewController(addTaskVC, animated: true)
    }
    
    // MARK: 建立圓形View
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
    
    // MARK: 建立日期Label
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
        
        print("\(year).\(month).\(day).\(weekdayString)")
        
        circleDateLabel.text = "\(year).\(month).\(day).\(weekdayString)" // "2023.06.13.Tue"
    }
    
    // MARK: 建立倒數計時器Label
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
    
    // MARK: 建立任務Label
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
