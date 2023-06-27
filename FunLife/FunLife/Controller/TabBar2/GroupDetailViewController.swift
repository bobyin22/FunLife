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
    var userGroupArray: [String] = []
    
    var fromGroupGetUserID = ""
    var fromGroupGetUserName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupGroupDetailView()
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
        
        // MARK: 允許邀請按鈕點擊有反應
        groupDetailView.inviteGroupBtn.addTarget(self, action: #selector(clickInvite), for: .touchUpInside)

    }
    
    // MARK: 點擊邀請按鈕觸發 彈跳出UIActivityViewController
    @objc func clickInvite() {
        print("🍎🍎🍎🍎")
        guard let image = UIImage(systemName: "bell"),
              let url = URL(string: "https://www.google.com") else { return }
        
        let shareSheertVC = UIActivityViewController(
        activityItems: [
            image,
            url
        ],
        applicationActivities: nil
        )
        present(shareSheertVC, animated: true)
    }
    
    // MARK: 抓取firebase上的資料
    func fetchAPI() {
        
        let db = Firestore.firestore()
        db.collection("group").whereField("members", arrayContains: "\(UserDefaults.standard.string(forKey: "myUserID")!)") .getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            // 拿到所有符合 member是使用者的group
            let userGroup = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: Group.self)
            }
            print("userGroup", userGroup)
            print("userGroup[0]", userGroup[0])                        // ["G0DQu4crcwLZJXlL8qpr"]
            print("userGroup[0].members[0]", userGroup[0].members[0])  // G0DQu4crcwLZJXlL8qpr
            print("成員有幾個", userGroup[0].members.count)              // 1
            self.fromGroupGetUserID = userGroup[0].members[0]
            self.getUserName()
            
            
            var indexNumber = 0
            
            // MARK: 取得成員名稱 userGroupArray
            let documents = snapshot.documents
            
            for document in documents {
                let data = document.data()
                guard let groupMembersArray = data["members"] as? [String] else { return }
                self.groupMembersArrays.append(contentsOf: groupMembersArray)
                indexNumber += 1
            }
            
            self.groupDetailView.groupDetailTableView.reloadData()
        }
    }
    
    // MARK: 拿G0DQu4crcwLZJXlL8qpr 去抓 users -> G0DQu4crcwLZJXlL8qpr -> name
    func getUserName() {
        let db = Firestore.firestore()
        db.collection("users").document(fromGroupGetUserID).getDocument { snapshot, error in
            if let error = error {
                print("Error getting document: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists else {
                print("snapshot不存在")
                return
            }
            
            if let data = snapshot.data(),
               let name = data["name"] as? String {
                self.fromGroupGetUserName = name
                // 把Bob塞給下一頁變數來接顯示在cell Label
                
                self.groupDetailView.passData = "\(self.fromGroupGetUserName)"
                print("self.groupDetailView.passData", self.groupDetailView.passData)
                
                print("抓到的UserName是: \(name)")
            } else {
                print("Invalid document data or name field does not exist")
            }
            
        }
    }
}
