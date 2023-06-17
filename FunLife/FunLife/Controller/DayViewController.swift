//
//  DayViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/17.
//

import UIKit
import FSCalendar

class DayViewController: UIViewController, FSCalendarDelegate {
    
    var calendar:FSCalendar!
    var formatter = DateFormatter()
    
    let myTableView = UITableView()
    let settingIconArray = ["list.bullet.clipboard.fill", "list.bullet.clipboard.fill", "list.bullet.clipboard.fill", "list.bullet.clipboard.fill", "list.bullet.clipboard.fill"]
    let settingTitleArray = ["任務1", "任務2", "任務3", "任務4", "任務5"]

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
    }
    
    func setupCalendar() {
        calendar = FSCalendar(frame: CGRect(x: 0.0, y: 90.0, width: self.view.frame.size.width, height: 300.0))
        calendar.scrollDirection = .vertical
        calendar.scope = .month
        self.view.addSubview(calendar)
    }
    
    
    // MARK: - Delegate
    // 點擊日，會印出當日日期
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "dd-MMM-yyyy"
        print("Date Selected == \(formatter.string(from: date))")
    }
    
    func setupMyTableView() {
        view.addSubview(myTableView)
        myTableView.backgroundColor = .systemGreen
        myTableView.backgroundColor = .systemYellow
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myTableView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 10),
            myTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            myTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            myTableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
}

extension DayViewController: UITableViewDelegate {
    
}

extension DayViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "DayTableViewCell",
                                                        for: indexPath) as? DayTableViewCell
        else {
            // 處理轉換失敗的情況，例如創建一個預設的 UITableViewCell
            return UITableViewCell()
        }
        
        cell.settingIcon.setImage(UIImage(systemName: settingIconArray[indexPath.row]), for: .normal)
        cell.settingInfo.text = settingTitleArray[indexPath.row]
        
        return cell
    }
}
