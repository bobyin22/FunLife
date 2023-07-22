//
//  SheetTaskViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/20.
//

import UIKit
import FirebaseFirestore

// 1️⃣ 老闆定義要做的事
protocol SheetTaskViewControllerDelegate: AnyObject {
    func passValue(_ VC: SheetTaskViewController, parameter: String)
    func passValueTime(_ VC: SheetTaskViewController, parameterTime: String)
}

class SheetTaskViewController: UIViewController {
    
    let myTaskTableView = UITableView()
    let firebaseManager = FirebaseManager()
    
    // 2️⃣ 建立一個變數是自己
    weak var delegate: SheetTaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 186/255, green: 129/255, blue: 71/255, alpha: 1)
        myTaskTableView.register(SheetTaskTableViewCell.self, forCellReuseIdentifier: "SheetTaskTableViewCell")
        myTaskTableView.delegate = self
        myTaskTableView.dataSource = self
        setupTableView()
        
        firebaseManager.delegate = self
        firebaseManager.fetchTodayTasks()
    }
    
    // MARK: 建立半截VC的tableView
    func setupTableView() {
        view.addSubview(myTaskTableView)
        myTaskTableView.backgroundColor = UIColor(red: 187/255, green: 129/255, blue: 72/255, alpha: 1)
        myTaskTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myTaskTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            myTaskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            myTaskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            // myTaskTableView.heightAnchor.constraint(equalToConstant: 200),
            myTaskTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
}

// MARK: 寫入自定義tableView的指派工作
extension SheetTaskViewController: UITableViewDelegate {
    
}

// MARK: 寫入自定義tableView的資料
extension SheetTaskViewController: UITableViewDataSource {
    
    // MARK: 幾個row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // taskFirebaseArray.count
        firebaseManager.taskFirebaseArray.count
    }
    
    // MARK: 每個Cell內要顯示的資料
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SheetTaskTableViewCell", for: indexPath) as? SheetTaskTableViewCell
        else {
            // 處理轉換失敗的情況，例如創建一個預設的 UITableViewCell
            return UITableViewCell()
        }
        
        // cell.settingInfo.text = taskFirebaseArray[indexPath.row]
        cell.settingInfo.text = firebaseManager.taskFirebaseArray[indexPath.row]
        // cell.settingTime.text = taskFirebaseTimeArray[indexPath.row]
        
        let hours = Int(firebaseManager.taskFirebaseTimeArray[indexPath.row])! / 3600
        let minutes = (Int(firebaseManager.taskFirebaseTimeArray[indexPath.row])! % 3600) / 60
        let seconds = Int(firebaseManager.taskFirebaseTimeArray[indexPath.row])! % 60
        let formattedTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        // homeView.circleTimerLabel.text = formattedTime
        cell.settingTime.text = formattedTime
        
        return cell
    }
    
    // MARK: 點選Cell執行的動作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("選到","\(firebaseManager.taskFirebaseArray[indexPath.row])")
        
        // 3️⃣ 使用的方法
        delegate?.passValue(self, parameter: firebaseManager.taskFirebaseArray[indexPath.row])
        
        delegate?.passValueTime(self, parameterTime: firebaseManager.taskFirebaseTimeArray[indexPath.row])
        
        dismiss(animated: true, completion: nil)
    }
    
    // 🍀 MARK: Row Deleting
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 若編輯模式為.delete --> 可執行刪除
        if editingStyle == .delete {
            firebaseManager.deleteTodayTask(deleteIndex: indexPath)
            // 執行刪除操作，例如從資料源中刪除對應的資料
            firebaseManager.taskFirebaseArray.remove(at: indexPath.row)         // indexPath.row --> 我們點擊的row
            firebaseManager.taskFirebaseTimeArray.remove(at: indexPath.row)     // indexPath.row --> 我們點擊的row
            tableView.deleteRows(at: [indexPath], with: .fade)       // [indexPath]--> 我們點擊的row (ex.[(section0, row5)])
        }
    }
    
}



extension SheetTaskViewController: FirebaseManagerSheetTaskVCDelegate {
    
    // 實作 FirebaseManagerDelegate 協議的方法，當 FirebaseManager 完成任務獲取後，通知重新載入數據
    func reloadData() {
        self.myTaskTableView.reloadData()
    }
    
}
