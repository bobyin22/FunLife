//
//  MonthViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/19.
//

import UIKit
import FSCalendar

class MonthViewController: UIViewController, FSCalendarDelegate {

    var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCalendar()
    }
    
    // MARK: 設定第三方套件日曆View尺寸
    func setupCalendar() {
        calendar = FSCalendar(frame: CGRect(x: 0.0, y: 90.0, width: self.view.frame.size.width, height: 300.0))
        calendar.scrollDirection = .horizontal
        calendar.scope = .month
        self.view.addSubview(calendar)
    }
    
    // MARK: - Delegate
    // MARK: 點擊日，會印出當日日期
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    }
    
}
