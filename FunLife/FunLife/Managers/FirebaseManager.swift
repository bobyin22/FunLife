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

class FirebaseManager {
        
    let db = Firestore.firestore()
    var documentID = ""
    
    // MARK: 把新任務傳至firebase
    func createTask(taskText: String) {
        // MARK: 把日期功能補在這
        let today = Date()
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
        let year = dateComponents.year!
        let month = dateComponents.month!
        let day = dateComponents.day! < 10 ? "0\(dateComponents.day!)" : "\(dateComponents.day!)"   // 如果小於10 加上0    大於10直接用
        
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
    
    // MARK: firebase成功拿到創建的獨一無二的ID
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
    
    // MARK: 每次翻轉後要更新秒數
    func modifyUser(counter: String, taskText: String) {
        
        let today = Date()
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
        let year = dateComponents.year!
        let month = dateComponents.month!
        var day = dateComponents.day! < 10 ? "0\(dateComponents.day!)" : "\(dateComponents.day!)"   //如果小於10 加上0    大於10直接用
//        var day = dateComponents.day! < 10 ? "0\(dateComponents.day!)" : "\(dateComponents.day!)"
        
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
    
    
}
