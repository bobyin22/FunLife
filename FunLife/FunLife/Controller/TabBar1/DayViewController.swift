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
    
    // MARK: firebase的任務文字
    var taskFirebaseArray: [String] = [""]
    
    // MARK: firebase的任務秒數
    var taskFirebaseTimeArray: [String] = [""]
    
    // MARK: 先建立字串到時候給firebase用
    var dayString = ""
    var monthString = ""
    
    var sumTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()
        
        // calendar.dataSource = self
        calendar.delegate = self
        
        setupMyTableView()
        myTableView.register(DayTableViewCell.self, forCellReuseIdentifier: "DayTableViewCell")
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.rowHeight = UITableView.automaticDimension
        myTableView.estimatedRowHeight = UITableView.automaticDimension
        fetchDayAPI()
    }
    
    
    // MARK: 設定第三方套件日曆View尺寸
    func setupCalendar() {
        calendar = FSCalendar(frame: CGRect(x: 0.0, y: 90.0, width: self.view.frame.size.width, height: 300.0))
        calendar.scrollDirection = .vertical
        calendar.scope = .month
        self.view.addSubview(calendar)
    }
    
    // MARK: - Delegate
    // MARK: 點擊日，會印出當日日期
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "dd-MMM-yyyy"
        print("Date Selected == \(formatter.string(from: date))")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd" // 顯示日期的格式，只保留日
        dayString = formatter.string(from: date)
        
        formatter.dateFormat = "M" // 顯示月份的格式，只保留月
        monthString = formatter.string(from: date)
        
        self.fetchDayAPI()
    }
    
    // MARK: 載入日期firebase任務與時間
    func fetchDayAPI() {
        sumTime = 0
        taskFirebaseArray.removeAll()
        taskFirebaseTimeArray.removeAll()
        let today = Date()
        let db = Firestore.firestore()
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
        
        // 如果還沒點擊dayString是空的，打今日的API
        if dayString == "" {
            // let year = dateComponents.year!
            let month = dateComponents.month!
            let day = dateComponents.day! < 10 ? "0\(dateComponents.day!)" : "\(dateComponents.day!)"
            
            db.collection("users")
                .document("\(UserDefaults.standard.string(forKey: "myUserID")!)")
                .collection("\(month).\(day)")
                .getDocuments { snapshot, error in
                    guard let snapshot else {
                        return
                    }
                    // print("snapshot", snapshot)
                    let userDayTask = snapshot.documents.compactMap { snapshot in try? snapshot.data(as: Users.self)}
                    var indexNumber = 0
                    
                    for index in userDayTask {
                        self.taskFirebaseArray.append(userDayTask[indexNumber].id!)       // MARK: 把firebase任務塞進我的taskFirebaseArray陣列
                        self.taskFirebaseTimeArray.append(userDayTask[indexNumber].timer) // MARK: 把firebase任務塞進我的taskFirebaseTimeArray陣列
                        
                        self.sumTime += Int(userDayTask[indexNumber].timer) ?? 0
                        // print(self.sumTime)
                        indexNumber += 1
                    }
                    self.myTableView.reloadData()
                }
        } else {
            db.collection("users")
                .document("\(UserDefaults.standard.string(forKey: "myUserID")!)")
                .collection("\(monthString).\(dayString)")
                .getDocuments { snapshot, error in
                    guard let snapshot else {
                        return
                    }
                    // print("snapshot", snapshot)
                    let userDayTask = snapshot.documents.compactMap { snapshot in try? snapshot.data(as: Users.self)}
                    var indexNumber = 0
                    
                    for index in userDayTask {
                        self.taskFirebaseArray.append(userDayTask[indexNumber].id!)       // MARK: 把firebase任務塞進我的taskFirebaseArray陣列
                        self.taskFirebaseTimeArray.append(userDayTask[indexNumber].timer) // MARK: 把firebase任務塞進我的taskFirebaseTimeArray陣列
                        self.sumTime += Int(userDayTask[indexNumber].timer) ?? 0
                        // print(self.sumTime)
                        indexNumber += 1
                    }
                    
                    self.myTableView.reloadData()
                }
        }
    }
    
    // MARK: 建置自訂義的tableView尺寸
    func setupMyTableView() {
        view.addSubview(myTableView)
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myTableView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 10),
            myTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            myTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            myTableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}

// MARK: 寫入自定義tableView的指派工作
extension DayViewController: UITableViewDelegate {
    
}

// MARK: 寫入自定義tableView的資料
extension DayViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "本日專注累計\(sumTime)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskFirebaseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "DayTableViewCell",
                                                        for: indexPath) as? DayTableViewCell
        else {
            // 處理轉換失敗的情況，例如創建一個預設的 UITableViewCell
            return UITableViewCell()
        }
        
        cell.settingInfo.text = taskFirebaseArray[indexPath.row]
        cell.settingTime.text = taskFirebaseTimeArray[indexPath.row]
        
        return cell
    }
}
