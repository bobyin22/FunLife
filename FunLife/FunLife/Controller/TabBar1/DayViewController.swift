//
//  DayViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/17.
//

import UIKit
import FSCalendar
import FirebaseFirestore
import FirebaseFirestoreSwift

class DayViewController: UIViewController, FSCalendarDelegate {
    
    var calendar: FSCalendar!
    var formatter = DateFormatter()
    let myTableView = UITableView()
    let firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()
        // view.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        
        // calendar.dataSource = self
        calendar.delegate = self
        
        setupMyTableView()
        myTableView.register(DayTableViewCell.self, forCellReuseIdentifier: "DayTableViewCell")
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.rowHeight = UITableView.automaticDimension
        myTableView.estimatedRowHeight = UITableView.automaticDimension
        // fetchDayAPI()
        
        navbarAndtabbarsetup()
        setupDayVCNavBarColor()
        firebaseManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseManager.fetchDayAPI()
        self.myTableView.reloadData()
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
        
        tabBarController?.tabBar.barTintColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
        tabBarController?.tabBar.shadowImage = UIImage()
        tabBarController?.tabBar.isTranslucent = false
    }
    
    // MARK: 設定第三方套件日曆View尺寸
    func setupCalendar() {
        // calendar = FSCalendar(frame: CGRect(x: 0.0, y:60.0, width: self.view.frame.size.width, height: 300.0))
        calendar = FSCalendar(frame: CGRect.zero)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendar)

        // 設定頂部對齊約束
        let topConstraint = calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        topConstraint.isActive = true

        // 設定其他約束
        NSLayoutConstraint.activate([
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendar.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        calendar.scrollDirection = .vertical
        calendar.scope = .month
        calendar.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        
        calendar.appearance.headerTitleColor = UIColor(red: 185/255, green: 131/255, blue: 69/255, alpha: 1) // .systemOrange
        // calendar.today = nil
        calendar.appearance.selectionColor = .blue
        calendar.appearance.weekdayTextColor = .white
        calendar.appearance.titleDefaultColor = .white
    }
    
    // MARK: - Delegate
    // MARK: 點擊日，會印出當日日期
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "dd-MMM-yyyy"
        print("Date Selected == \(formatter.string(from: date))")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd" // 顯示日期的格式，只保留日
        firebaseManager.dayString = formatter.string(from: date)
        // dayString = formatter.string(from: date)
        
        formatter.dateFormat = "M" // 顯示月份的格式，只保留月
        firebaseManager.monthString = formatter.string(from: date)
        // monthString = formatter.string(from: date)
        
        // self.fetchDayAPI()
        firebaseManager.fetchDayAPI()
    }
    
    func setupDayVCNavBarColor() {
        let dayVCNavBarColorView = UIView()
        view.addSubview(dayVCNavBarColorView)
        dayVCNavBarColorView.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        dayVCNavBarColorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dayVCNavBarColorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            dayVCNavBarColorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            dayVCNavBarColorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            dayVCNavBarColorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            // dayVCNavBarColorView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    // MARK: 建置自訂義的tableView尺寸
    func setupMyTableView() {
        view.addSubview(myTableView)
        myTableView.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myTableView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 0),
            myTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            myTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            myTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            // myTableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}

// MARK: 寫入自定義tableView的指派工作
extension DayViewController: UITableViewDelegate {
    
}

// MARK: 寫入自定義tableView的資料
extension DayViewController: UITableViewDataSource {
    
    // 分组头即将要显示
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView,
                   forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor(red: 185/255, green: 131/255, blue: 69/255, alpha: 1) // UIColor.orange
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        // header.textLabel?.frame = header.frame
        header.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        // 設定左邊距約束
        let leadingConstraint = header.textLabel?.leadingAnchor.constraint(equalTo: header.contentView.leadingAnchor, constant: 10)
        leadingConstraint?.isActive = true
        
        header.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            header.contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            header.contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            header.contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            header.contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            // myTableView.heightAnchor.constraint(equalToConstant: 300)
        ])
        // header.textLabel?.backgroundColor = .blue
        header.textLabel?.textAlignment = .left
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let hours = firebaseManager.sumTime / 3600
        let minutes = firebaseManager.sumTime % 3600 / 60
        let seconds = firebaseManager.sumTime % 60
        let formattedTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        return "本日專注累計\(formattedTime)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firebaseManager.taskFirebaseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "DayTableViewCell",
                                                        for: indexPath) as? DayTableViewCell
        else {
            // 處理轉換失敗的情況，例如創建一個預設的 UITableViewCell
            return UITableViewCell()
        }
        cell.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        cell.settingInfo.text = firebaseManager.taskFirebaseArray[indexPath.row]
        
        let hours = Int(firebaseManager.taskFirebaseTimeArray[indexPath.row])! / 3600
        let minutes = (Int(firebaseManager.taskFirebaseTimeArray[indexPath.row])! % 3600) / 60
        let seconds = Int(firebaseManager.taskFirebaseTimeArray[indexPath.row])! % 60
        let formattedTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        // homeView.circleTimerLabel.text = formattedTime
        cell.settingTime.text = formattedTime
        
        return cell
        
    }
}

extension DayViewController: FirebaseManagerDelegate {
    func renderText() {}
    
    func kfRenderImg() {}
    
    // 設定tableView資料源後調用的方法
        func reloadData() {
            myTableView.reloadData()
        }
}
