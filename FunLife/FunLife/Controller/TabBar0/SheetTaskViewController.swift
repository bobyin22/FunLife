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
        
    // MARK: firebase的任務文字
    var taskFirebaseArray: [String] = [""]
    
    // MARK: firebase的任務秒數
    var taskFirebaseTimeArray: [String] = [""]
    
    var sumTime = 0
    
    // 2️⃣ 建立一個變數是自己
    weak var delegate: SheetTaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 186/255, green: 129/255, blue: 71/255, alpha: 1)
        myTaskTableView.register(SheetTaskTableViewCell.self, forCellReuseIdentifier: "SheetTaskTableViewCell")
        myTaskTableView.delegate = self
        myTaskTableView.dataSource = self
        setupTableView()
        
        fetchTodayTasks()
        
    }
    
    // MARK: 點擊任務 半截VC要fetch的任務資料
    func fetchTodayTasks() {
        sumTime = 0
        taskFirebaseArray.removeAll()
        taskFirebaseTimeArray.removeAll()
        
        let today = Date()
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
        var year = dateComponents.year!
        var month = dateComponents.month!
        let day = dateComponents.day! < 10 ? "0\(dateComponents.day!)" : "\(dateComponents.day!)"
        
        let db = Firestore.firestore()
        
        db.collection("users").document("\(UserDefaults.standard.string(forKey: "myUserID")!)").collection("\(month).\(day)").getDocuments { snapshot, error in
            guard let snapshot else {
                return
            }
            
            let userDayTask = snapshot.documents.compactMap { snapshot in try? snapshot.data(as: Users.self)}
            var indexNumber = 0
            
            for index in userDayTask {
                self.taskFirebaseArray.append(userDayTask[indexNumber].id!) // MARK: 把firebase任務塞進我的taskFirebaseArray陣列
                self.taskFirebaseTimeArray.append(userDayTask[indexNumber].timer) // MARK: 把firebase任務塞進我的taskFirebaseTimeArray陣列
                indexNumber += 1
            }
            
            self.myTaskTableView.reloadData()
        }
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
        taskFirebaseArray.count
    }
    
    // MARK: 每個Cell內要顯示的資料
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SheetTaskTableViewCell", for: indexPath) as? SheetTaskTableViewCell
        else {
            // 處理轉換失敗的情況，例如創建一個預設的 UITableViewCell
            return UITableViewCell()
        }
        
        cell.settingInfo.text = taskFirebaseArray[indexPath.row]
        // cell.settingTime.text = taskFirebaseTimeArray[indexPath.row]
        
        let hours = Int(taskFirebaseTimeArray[indexPath.row])! / 3600
        let minutes = (Int(taskFirebaseTimeArray[indexPath.row])! % 3600) / 60
        let seconds = Int(taskFirebaseTimeArray[indexPath.row])! % 60
        let formattedTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        // homeView.circleTimerLabel.text = formattedTime
        cell.settingTime.text = formattedTime
        
        return cell
    }
    
    // MARK: 點選Cell執行的動作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("選到","\(taskFirebaseArray[indexPath.row])")
        
        // 3️⃣ 使用的方法 
        delegate?.passValue(self, parameter: taskFirebaseArray[indexPath.row])
        
        delegate?.passValueTime(self, parameterTime: taskFirebaseTimeArray[indexPath.row])
        
        dismiss(animated: true, completion: nil)
    }
    
    // 🍀 MARK: Row Deleting
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 若編輯模式為.delete --> 可執行刪除
        if editingStyle == .delete {

            // 把firebase當日任務刪除
            let today = Date()
            let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
            // var year = dateComponents.year!
            var month = dateComponents.month!
            let day = dateComponents.day! < 10 ? "0\(dateComponents.day!)" : "\(dateComponents.day!)"
            
            let db = Firestore.firestore()
            let documentID = taskFirebaseArray[indexPath.row] // 要刪除的文檔的 ID
            let documentRef = db.collection("users").document("\(UserDefaults.standard.string(forKey: "myUserID")!)").collection("\(month).\(day)").document(documentID)

            documentRef.delete { error in
                if let error = error {
                    print("Error removing document: \(error)")
                } else {
                    print("Document successfully removed!")
                    // 在刪除成功後，你可能還需要更新你的資料源和 tableView 的顯示
                    // 執行刪除操作，例如從資料源中刪除對應的資料
                    self.taskFirebaseArray.remove(at: indexPath.row)         // indexPath.row --> 我們點擊的row
                    self.taskFirebaseTimeArray.remove(at: indexPath.row)     // indexPath.row --> 我們點擊的row
                    // 2. 刪除tableView上的row
                    tableView.deleteRows(at: [indexPath], with: .fade)       // [indexPath]--> 我們點擊的row (ex.[(section0, row5)])
                }
            }
            
        }
    }
    
}
