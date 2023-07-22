//
//  FirebaseManager.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/7/16.
//

import UIKit
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: Manager抓抓完今日任務資料要通知SheetTaskVC (SheetTaskVC)
protocol FirebaseManagerDelegate: AnyObject {
    func reloadData()
}

class FirebaseManager {
    
    let db = Firestore.firestore()
    var documentID = ""
    let today = Date()
    lazy var dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
    lazy var year = {
        self.dateComponents.year!
    }
    lazy var month = dateComponents.month!
    lazy var day = dateComponents.day! < 10 ? "0\(dateComponents.day!)" : "\(dateComponents.day!)"   // 如果小於10 加上0    大於10直接用
    
    // MARK: SheetTaskVC使用的變數
    var sumTime = 0
    var taskFirebaseArray: [String] = [""]      // MARK: firebase的任務文字
    var taskFirebaseTimeArray: [String] = [""]  // MARK: firebase的任務秒數
    weak var delegate: FirebaseManagerDelegate?
    
    // MARK: DayVC使用的變數 (先建立字串到時候給firebase用)
    var dayString = ""
    var monthString = ""
    
    // MARK: 把新任務傳至firebase (AddTaskVC)
    func createTask(taskText: String) {
        // MARK: 把日期功能補在這
        
        let task = ["timer": "0", "user": "包伯"]
        let bobDocumentRef = db.collection("users").document("\(UserDefaults.standard.string(forKey: "myUserID")!)")
        let nextTaskCollectionRef = bobDocumentRef.collection("\(month).\(day)" ?? "沒輸入")
        
        nextTaskCollectionRef.document(taskText).setData(task) { error in
            if let error = error {
                print("Error creating task: \(error)")
            } else {
                print("Task textField文字有成功存至cloud firebase")
            }
        }
    }
    
    // MARK: firebase成功拿到創建的獨一無二的ID (HomeVC)
    func createANewUserIDDocument() {
        // let task = ["timer": "0", "user": "包伯"]
        let newDocumentID = db.collection("users").document()               // firebase建立一個亂數DocumentID
        self.documentID = newDocumentID.documentID                          // firebase建立一個亂數DocumentID 並賦值給變數
        UserDefaults.standard.set(self.documentID, forKey: "myUserID")      // 把亂數DocumentID 塞在 App的UserDefault裡
        
        // 建立firebase資料 ID 其他空
        db.collection("users").document("\(self.documentID)").setData(["name": ""]) { error in
            if let error = error {
                print("Document 建立失敗")
            } else {
                print("Document 建立成功")
            }
        }
    }
    
    // MARK: 每次翻轉後要更新秒數 (HomeVC)
    func modifyUser(counter: String, taskText: String) {
        
        let documentReference = db.collection("users")
            .document("\(UserDefaults.standard.string(forKey: "myUserID")!)")
            .collection("\(month).\(day)")
            .document(taskText)         // // MARK: 傳上 00:00:12
        
        documentReference.getDocument { document, error in
            guard let document, document.exists,
                  var user = try? document.data(as: Users.self) else {  // // MARK: 這裡就有用到自定義的struct資料結構
                return
            }
            
            user.timer = String(counter)
            do {
                try documentReference.setData(from: user)
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: 點擊任務 半截VC要fetch的任務資料 (SheetTaskVC)
    func fetchTodayTasks() {
        sumTime = 0
        taskFirebaseArray.removeAll()
        taskFirebaseTimeArray.removeAll()
        
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
            
            self.delegate?.reloadData()
        }
    }
    
    // MARK: 左滑可以刪除任務 (SheetTaskVC)
    func deleteTodayTask(deleteIndex: IndexPath) {
        // 把firebase當日任務刪除
        let documentID = taskFirebaseArray[deleteIndex.row] // 要刪除的文檔的 ID
        let documentRef = db.collection("users")
            .document("\(UserDefaults.standard.string(forKey: "myUserID")!)")
            .collection("\(month).\(day)").document(documentID)
        documentRef.delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    // MARK: 載入日期firebase任務與時間 (DayVC)
    func fetchDayAPI() {
        sumTime = 0
        taskFirebaseArray.removeAll()
        taskFirebaseTimeArray.removeAll()
   
        // 如果還沒點擊dayString是空的，打今日的API
        if dayString == "" {

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
                    // self.myTableView.reloadData()
                    self.delegate?.reloadData()
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
                    
                    // self.myTableView.reloadData()
                    self.delegate?.reloadData()
                }
        }
    }
    
}
