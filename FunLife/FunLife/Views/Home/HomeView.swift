//
//  HomeView.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/7/1.
//

import UIKit

class HomeView: UIView {

    // MARK: 建立一個UI 圓形View
    let circleView: UIView = {
        let circleView = UIView()
        return circleView
    }()
    
    // MARK: 建立一個UI 計時時間Label
    var circleTimerLabel: UILabel = {
        let circleTimerLabel = UILabel()
        return circleTimerLabel
    }()
    
    // MARK: 建立一個UI 計時日期Label
    let circleDateLabel: UILabel = {
        let circleDateLabel = UILabel()
        return circleDateLabel
    }()
    
    // MARK: 建立一個UI 任務Button
    let circleTaskButton: UIButton = {
        let circleTaskButton = UIButton()
        return circleTaskButton
    }()
        
    // MARK: 建立一個UI 顯示目前正反面Label
    var label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: 初始init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCircleUI()
        setupDate()
        setupTimer()
        setupTask()
        setupFlipLabel()
    }
    
    // MARK: UI建立圓形View
    func setupCircleUI() {
        circleView.backgroundColor = .systemYellow
        addSubview(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -200),
            circleView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: -150),
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
    
    // MARK: UI建立倒數計時器Label
    func setupTimer() {
        addSubview(circleTimerLabel)
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
        addSubview(circleTaskButton)
        circleTaskButton.setTitle("我的今日任務", for: .normal)
        circleTaskButton.backgroundColor = .systemGreen
        circleTaskButton.setTitleColor(UIColor.black, for: .normal)
        circleTaskButton.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        circleTaskButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleTaskButton.topAnchor.constraint(equalTo: circleTimerLabel.bottomAnchor, constant: 20),
            circleTaskButton.leadingAnchor.constraint(equalTo: circleTimerLabel.centerXAnchor, constant: -40)
        ])
        
    }
    
    // MARK: UI建立日期Label
    func setupDate() {
        addSubview(circleDateLabel)
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
    
    // MARK: 建立UI 顯示目前在哪一面的Label
    func setupFlipLabel() {
        label = UILabel(frame: CGRect(x: 140, y: 450, width: 200, height: 50))
        // label.center = view.center
        // label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24)
        addSubview(label)
    }
    
    // MARK: 需要寫上
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}