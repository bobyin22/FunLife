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
    
    // let shared = XXXManager()
    
    let db = Firestore.firestore()
    
    
    func createTask(taskText: String) {
        
        let today = Date()
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
        let year = dateComponents.year!
        let month = dateComponents.month!
        let day = dateComponents.day! < 10 ? "0\(dateComponents.day!)" : "\(dateComponents.day!)"   //如果小於10 加上0    大於10直接用
        
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
        
//        nextTaskCollectionRef.document(addTaskView.addTaskTextField.text ?? "沒輸入").setData(task) { error in
//            if let error = error {
//                print("Error creating task: \(error)")
//            } else {
//                print("Task textField文字有成功存至cloud firebase")
//            }
//        }
//        print("函式執行後", UserDefaults.standard.dictionaryRepresentation())
    }
    
}
