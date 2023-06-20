//
//  SheetTaskViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/20.
//

import UIKit
import FirebaseFirestore

class SheetTaskViewController: UIViewController {
    
    let myTaskTableView = UITableView()
        
    // MARK: firebase的任務文字
    var taskFirebaseArray: [String] = [""]
    
    // MARK: 先建立字串到時候給firebase用
    var dayString = ""
    var monthString = ""
    
    var sumTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        myTaskTableView.register(SheetTaskTableViewCell.self, forCellReuseIdentifier: "SheetTaskTableViewCell")
        myTaskTableView.delegate = self
        myTaskTableView.dataSource = self
        setupTableView()
        
        fetchAPI()
    }
    
    // MARK: 點擊任務 半截VC要fetch的任務資料
    func fetchAPI() {
        taskFirebaseArray.removeAll()
        
        let today = Date()
        
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
                
        monthString = String(dateComponents.month!)
        dayString = String(dateComponents.day!)
        
        let db = Firestore.firestore()
        
        // print("月日", "\(monthString).\(dayString)")
        
        db.collection("users").document("Bob").collection("\(monthString).\(dayString)").getDocuments { snapshot, error in
            guard let snapshot else {
                return
            }
            // print("snapshot", snapshot)
            
            let userDayTask = snapshot.documents.compactMap { snapshot in try? snapshot.data(as: Users.self)}
            
            var indexNumber = 0
            
            // print("這是", userDayTask)
            
            for index in userDayTask {
                self.taskFirebaseArray.append(userDayTask[indexNumber].id!)
                
                // print("userDayTask[indexNumber].id!",userDayTask[indexNumber].id!)
                
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
        
        return cell
    }
    
    // MARK: 點選Cell執行的動作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("選到ㄌㄜ","\(taskFirebaseArray[indexPath.row])")
        
    }
    
}
