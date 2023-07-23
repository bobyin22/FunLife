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
    func reloadData()       // 讓VC的tableView或CollectionView重新更新畫面
    func kfRenderImg()      // ProfileVC載入圖
    func renderText()       // ProfileVC載入字
}

class FirebaseManager {
    
    // MARK: 各個函式都會用到
    let db = Firestore.firestore()
    var documentID = ""
    let today = Date()
    lazy var dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
    lazy var year = {
        self.dateComponents.year!
    }
    lazy var month = dateComponents.month!
    lazy var day = dateComponents.day! < 10 ? "0\(dateComponents.day!)" : "\(dateComponents.day!)"
    
    // MARK: SheetTaskVC 使用的變數
    var sumTime = 0
    var taskFirebaseArray: [String] = [""]      // MARK: firebase的任務文字
    var taskFirebaseTimeArray: [String] = [""]  // MARK: firebase的任務秒數
    weak var delegate: FirebaseManagerDelegate?
    
    // MARK: DayVC 使用的變數(先建立字串到時候給firebase用)
    var dayString = ""
    var monthString = ""
    
    // MARK: GroupListVC 使用的變數
    var userInGroupClassNameArray: [String] = []      // 用來存教室名稱 ["教室1", "教室2"]
    var userInGroupIDNameArray: [String] = []         // 用來存教室ID [ "iqbjs3", "klabc1"]
    
    // MARK: GroupDetailClassVC 使用的變數
    var classMembersIDArray: [String] = []                      // 空陣列，要接住下方轉換成的 ["成員1ID", "成員2ID"]
    var classMembersTimeSum: Int = 0
    var classMembersTimeDictionary: [String: Int] = [:]         //
    var indexNumber = 0                                         // 獲取名字
    var classMembersNameArray: [String] = []                    // 空陣列，要接住下方從 ["成員1ID", "成員2ID"] -> ["成員1Name", "成員2Name"]
    var classMembersImageArray: [String] = []                   // 空陣列
    var classMembersIDDictionary: [String: String] = [:]        //
    var classMembersImageDictionary: [String: String] = [:]     //
    
    // MARK: ProfileVC 使用的變數
    var profileVCImageUrl: URL = URL(string: "https://example.com/image.png")!
    var profileVCPassString = ""
    
    
    // MARK: 把新任務傳至firebase (AddTaskVC)
    func createTask(taskText: String) {
        
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
                  var user = try? document.data(as: Users.self) else {  // 這裡用到自定義的struct資料結構
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

        let collectionPath: String
        if dayString.isEmpty {
            collectionPath = "\(month).\(day)"
        } else {
            collectionPath = "\(monthString).\(dayString)"
        }

        db.collection("users")
            .document("\(UserDefaults.standard.string(forKey: "myUserID")!)")
            .collection(collectionPath)
            .getDocuments { snapshot, error in
                guard let snapshot = snapshot else {
                    return
                }
                let userDayTask = snapshot.documents.compactMap { snapshot in try? snapshot.data(as: Users.self) }
                var indexNumber = 0
                
                for index in userDayTask {
                    self.taskFirebaseArray.append(userDayTask[indexNumber].id!) // MARK: 把firebase任務塞進我的taskFirebaseArray陣列
                    self.taskFirebaseTimeArray.append(userDayTask[indexNumber].timer) // MARK: 把firebase任務塞進我的taskFirebaseTimeArray陣列
                    self.sumTime += Int(userDayTask[indexNumber].timer) ?? 0
                    indexNumber += 1
                }

                self.delegate?.reloadData()
            }
    }
    
    // MARK: 抓取firebase上的資料 (MyGroupListVC)
    func fetchGroupListAPI() {
                
        // MARK: group下document，且 members欄是使用者，才顯示教室
        db.collection("group").whereField("members", arrayContains: "\(UserDefaults.standard.string(forKey: "myUserID")!)").addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            let userGroup = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: Group.self)
            }
            
            var indexNumber = 0
            
            self.userInGroupClassNameArray.removeAll()
            self.userInGroupIDNameArray.removeAll()
            
            // MARK: 取得教室名稱 userGroupArray
            for index in userGroup {
                self.userInGroupClassNameArray.append(userGroup[indexNumber].roomName)
                print("🥵userGroupArray", self.userInGroupClassNameArray)
                print("🥵userGroup", userGroup)
                
                self.userInGroupIDNameArray.append(userGroup[indexNumber].groupID)
                print("😎userGroupArray", self.userInGroupIDNameArray)
                print("😎userGroup", userGroup)
                indexNumber += 1
            }
            self.delegate?.reloadData()
        }
    }
    
    // MARK: 建立firebase群組 (CreateGroupVC)
    func postNewGroupAPI(groupName: String) {
        let db = Firestore.firestore()
        let newDocumentGroupID = db.collection("group").document()      // firebase建立一個亂數DocumentID
        let documentID = newDocumentGroupID.documentID                  // firebase建立一個亂數DocumentID 並賦值給變數
        UserDefaults.standard.set(documentID, forKey: "myGroupID")      // 把亂數DocumentID 塞在 App的UserDefault裡
        
        let task = ["groupID": "\(newDocumentGroupID.documentID)",
                    "founder": "\(UserDefaults.standard.string(forKey: "myUserID")!)",
                    "roomName": "\(groupName)",   // cell.createGroupTextField.text!
                    "members": ["\(UserDefaults.standard.string(forKey: "myUserID")!)"],     // 把founder放入member中
        ] as [String : Any]
        
        // 把創立的群組資料傳到firebase
        db.collection("group").document("\(newDocumentGroupID.documentID)").setData(task) { error in
            if let error = error {
                print("Document 建立失敗")
            } else {
                print("Document 建立成功")
            }
        }
    }
    
    // MARK: 抓取firebase上 有member下的 userID (GroupDetailClassVC)
    // 用自己的ID去 找有沒有這樣的document
    // 拿到 ["成員1的ID", "成員2的ID"]
    func fetchIDAPI(parameterFetchClassID: String) {
        let documentRef = db.collection("group").document(parameterFetchClassID).getDocument { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            let memberNSArray = snapshot.data()!
            if let members = memberNSArray["members"] as? [String] {
                self.classMembersIDArray = members
            }
            self.fetchTimeAPI()
            self.fetchNameAPI()                 // 去呼叫另外函式 轉拿 ["成員1的Name", "成員2的Name"]
            self.delegate?.reloadData()
        }
    }
    
    // MARK: userID去拿當日的Timer (GroupDetailClassVC)
    func fetchTimeAPI() {
        
        // MARK: 依據幾個member跑幾次
        for classMemberID in classMembersIDArray {
            let documentRef = db.collection("users").document(classMemberID).collection("\(month).\(day)").addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else { return }
                
                self.classMembersTimeSum = 0   // 換人時間歸零
                // MARK: 依據單一member，任務有幾個跑幾次
                for document in snapshot.documents {
                    guard let eachTaskTimer = document.data()["timer"] as? String else { return }    // 轉型成String
                    self.classMembersTimeSum += Int(eachTaskTimer)!
                }
                self.classMembersTimeDictionary[classMemberID] = self.classMembersTimeSum
                
                // MARK: 加完改變
                DispatchQueue.main.async {
                    self.delegate?.reloadData()
                }
            }
        }
    }
    
    // MARK: 拿userID陣列去 fetch抓 userName陣列 (GroupDetailClassVC)
    // 拿到 ["成員1的Name", "成員2的Name"]
    func fetchNameAPI() {
        // 走2次
        indexNumber = 0
        classMembersNameArray.removeAll()
        classMembersImageArray.removeAll()
        
        for memberID in classMembersIDArray {
            db.collection("users").document("\(classMembersIDArray[indexNumber])").getDocument { snapshot, error in
                
                guard let snapshot = snapshot else { return }
                // 名字
                self.classMembersIDDictionary[memberID] = "\(snapshot.data()!["name"]!)"
                self.classMembersNameArray.append("\(snapshot.data()!["name"]!)")
                // 照片
                self.classMembersImageDictionary[memberID] = "\(snapshot.data()!["image"]!)"
                self.classMembersImageArray.append("\(snapshot.data()!["image"]!)")
                
                self.delegate?.reloadData()
            }
            self.indexNumber += 1
        }
    }
    
    // MARK: 名字上傳至firestore database (ProfileVC)
    func modifyAPIName(paramaterUserName: String) {
        db.collection("users").document("\(UserDefaults.standard.string(forKey: "myUserID")!)").updateData(["name": paramaterUserName]) { error in
            if let error = error {
                print("Document 建立失敗")
            } else {
                print("Document 建立成功")
            }
        }
    }
    
    // MARK: 一進入畫面去抓取firebase圖片 (ProfileVC)
    // users -> 個人ID -> image: "" 拿資料
    func fetchMyImage() {
        let db = Firestore.firestore()
        db.collection("users").document(UserDefaults.standard.string(forKey: "myUserID")!).getDocument() { snapshot, error in
             guard let snapshot = snapshot,
                   let data = snapshot.data() else { return }
            
            // 如果裡面有url載入
            // 如果沒有url，不做事
            if snapshot.data()!["image"] == nil {
                return
            } else {
                print("👻snapshot.data()!", snapshot.data()!["image"]!)

                if let imageUrlString = snapshot.data()?["image"] as? String,
                   let imageUrl = URL(string: imageUrlString) {
                    self.profileVCImageUrl = imageUrl
                    // self.profileView.profilePhotoImageView.kf.setImage(with: imageUrl)
                    self.delegate?.kfRenderImg()
                }
            }

            if snapshot.data()!["name"] == nil {
                return
            } else {
                // self.profileView.profileNameTextField.text = snapshot.data()?["name"]! as? String
                self.profileVCPassString = snapshot.data()?["name"]! as? String ?? "nil"
                self.delegate?.renderText()
            }
            
        }
    }
    
    // MARK: 把url傳到使用者 (ProfileVC)
    func passUrlToUserFirebaseDataBase(myUrlString: String) {
        let db = Firestore.firestore()
        db.collection("users").document("\(UserDefaults.standard.string(forKey: "myUserID")!)").updateData(["image": myUrlString]) { error in
            if let error = error {
                print("Document 建立失敗")
            } else {
                
                print("Document 建立成功")
            }
        }
    }
    
}
