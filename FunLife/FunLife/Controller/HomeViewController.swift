//
//  HomeViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/15.
//

import UIKit

class HomeViewController: UIViewController {          //: BaseViewController

    let circleView = UIView()           // 圓形View
    let circleTimerLabel = UILabel()    // 計時時間Label
    let circleDateLabel = UILabel()    // 計時時間Label
    let circleTaskLabel = UILabel()    // 任務Label
    var settingSButton = UIBarButtonItem()
    var addButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray
        
        setupNavigation()
        setupCircleUI()
        setupDate()
        setupTimer()
        setupTask()
        
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
        circleTimerLabel.text = "00:00:00"
        circleTimerLabel.font = UIFont(name: "Helvetica", size: 50)
        circleTimerLabel.backgroundColor = .systemRed
        circleTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleTimerLabel.topAnchor.constraint(equalTo: circleDateLabel.bottomAnchor, constant: 10),
            circleTimerLabel.leadingAnchor.constraint(equalTo: circleView.centerXAnchor, constant: -95)
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
