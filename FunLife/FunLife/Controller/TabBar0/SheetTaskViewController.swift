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
        view.backgroundColor = UIColor(red: 175/255, green: 238/255, blue: 238/255, alpha: 1)//.orange
        
        myTaskTableView.register(SheetTaskTableViewCell.self, forCellReuseIdentifier: "SheetTaskTableViewCell")
        myTaskTableView.delegate = self
        myTaskTableView.dataSource = self
        setupTableView()
        
        fetchAPI()
    }
    
    // MARK: 點擊任務 半截VC要fetch的任務資料
    func fetchAPI() {
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
        myTaskTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myTaskTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            myTaskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            myTaskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            myTaskTableView.heightAnchor.constraint(equalToConstant: 200)
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
        cell.settingTime.text = taskFirebaseTimeArray[indexPath.row]
        
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
    
}
