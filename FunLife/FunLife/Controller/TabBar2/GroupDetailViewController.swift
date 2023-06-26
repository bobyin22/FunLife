//
//  GroupDetailViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/24.
//

import UIKit
import FirebaseFirestore

class GroupDetailViewController: UIViewController {

    // MARK: 生成自定義View的實體
    let groupDetailView = GroupDetailView()
    
    var groupID: String = ""
    var groupMembersArrays: [String] = []
    var userGroupArray: [String] = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white //.systemGray2
        setupGroupDetailView()
        
        // print("傳進來的groupID是", groupID)
        groupDetailView.groupDetailNameLabel.text = groupID
        fetchAPI()
    }
    
    // MARK: 把自定義的View設定邊界
    func setupGroupDetailView() {
        view.addSubview(groupDetailView)

        groupDetailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            groupDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            groupDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            groupDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: 抓取firebase上的資料
    func fetchAPI() {
        
        let db = Firestore.firestore()
        db.collection("group").whereField("members", arrayContains: "\(UserDefaults.standard.string(forKey: "myUserID")!)") .getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            let userGroup = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: Group.self)
            }
            
            
            var indexNumber = 0
            
            // MARK: 取得成員名稱 userGroupArray
            let documents = snapshot.documents
            
            for document in documents {
                let data = document.data()
                guard let groupMembersArray = data["members"] as? [String] else { return }
                self.groupMembersArrays.append(contentsOf: groupMembersArray)
                indexNumber += 1
            }
            
            indexNumber = 0
            
            for index in userGroup {
                self.userGroupArray.append(userGroup[indexNumber].roomName)
                //self.groupMembersArray.append(userGroup[indexNumber].members)
                indexNumber += 1
            }
            print("確認成員", self.userGroupArray)
            self.groupDetailView.groupDetailTableView.reloadData()
            // self.groupListTableView.reloadData()
        }
        
//        db.collection("group").document("\(UserDefaults.standard.string(forKey: "myUserID")!)").getDocument { (document, error) in
//
//            if let document = document, document.exists {
//                // print(document.documentID, document.data()!)
//                print(document.data()!["name"]!)
//
//                self.groupDetailView.passData = "\(document.data()!["name"]!)"
//                self.groupDetailView.groupDetailTableView.reloadData()
//
//            } else {
//                print("Document does not exist")
//            }
//
//        }
    }
    
}
