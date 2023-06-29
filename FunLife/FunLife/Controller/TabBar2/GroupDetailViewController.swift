//
//  GroupDetailViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/24.
//

import UIKit
import FirebaseFirestore

class GroupDetailViewController: UIViewController {
    
    let groupDetailView = GroupDetailView()     // MARK: 生成自定義View的實體
    let groupDetailTableView = UITableView()    // MARK: UI 建立一個TableView

    var classNameString: String = ""            // 讓Label吃到上一頁傳來的教室名稱
    var classMembersIDArray: [String] = []      // 空陣列，要接住下方轉換成的 ["成員1ID", "成員2ID"]
    var classMembersNameArray: [String] = []    // 🍎空陣列，要接住下方從 ["成員1ID", "成員2ID"] -> ["成員1Name", "成員2Name"]
    var indexNumber = 0                         // 🍎用
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetchIDAPI()
        
        view.backgroundColor = .white
        setupGroupDetailView()
        setupGroupDetailTableView()
        groupDetailTableView.register(GroupDetailTableViewCell.self, forCellReuseIdentifier: "GroupDetailTableViewCell")
        groupDetailTableView.delegate = self
        groupDetailTableView.dataSource = self
        
        groupDetailView.groupDetailNameLabel.text = classNameString // 讓Label吃到上一頁傳來的教室名稱
        print("朋友的GroupID", UserDefaults.standard.string(forKey: "FriendGroupID"))
        
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
        guard let url = URL(string: "FunLife://\(UserDefaults.standard.string(forKey: "myGroupID")!)") else { return }
        let shareSheertVC = UIActivityViewController( activityItems: [url], applicationActivities: nil )
        present(shareSheertVC, animated: true)
    }
    
    // MARK: 建立群組tablview的AutoLayout
    func setupGroupDetailTableView() {
        view.addSubview(groupDetailTableView)
        groupDetailTableView.backgroundColor = .systemGreen
        groupDetailTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupDetailTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            groupDetailTableView.leadingAnchor.constraint(equalTo: groupDetailView.leadingAnchor, constant: 0),
            groupDetailTableView.trailingAnchor.constraint(equalTo: groupDetailView.trailingAnchor, constant: 0),
            groupDetailTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -250),
        ])
    }
    
    // MARK: 抓取firebase上 有member下的 userID (用自己的ID去 找有沒有這樣的document)
    // 拿到 ["成員1的ID", "成員2的ID"]
    func fetchIDAPI() {
        
        let db = Firestore.firestore()
        
        let documentRef = db.collection("group").document(UserDefaults.standard.string(forKey: "FriendGroupID")!).getDocument { snapshot, error in
            guard let snapshot = snapshot else { return }
            //print("snapshot", snapshot) // <FIRDocumentSnapshot: 0x600003e88140>
            
            let memberNSArray = snapshot.data()!  // 這時候是一個NSArray
            if let members = memberNSArray["members"] as? [String] {  // 轉成Swift Array 拿到 ["成員1號ID", "成員2號ID"]
                //print("members:", members)
                self.classMembersIDArray = members
            }
            
            self.groupDetailTableView.reloadData()
            self.fetchNameAPI()
        }
    }
    
    // MARK: 拿userID陣列去 fetch抓 userName陣列
    // 拿到 ["成員1的Name", "成員2的Name"]
    func fetchNameAPI() {
        // 走2次
        for _ in 0..<classMembersIDArray.count {
            print("🍎classMembersIDArray", classMembersIDArray)
            
            let db = Firestore.firestore()
            print("⭐️classMembersIDArray[數字]", self.classMembersIDArray[self.indexNumber])
            db.collection("users").document("\(classMembersIDArray[indexNumber])").getDocument { snapshot, error in
                
                guard let snapshot = snapshot else { return }
                // print("snapshot", snapshot)                                          // <FIRDocumentSnapshot: 0x600001c401e0>
                // print("snapshot.data()", snapshot.data()!)                           // 得到 ["name": user1]
                print("⚠️snapshot.data()是", snapshot.data()!["name"]!)                // 得到 user1
                self.classMembersNameArray.append("\(snapshot.data()!["name"]!)")
                print("🍀classMembersNameArray", self.classMembersNameArray)
                self.groupDetailTableView.reloadData()
            }
            self.indexNumber += 1
        }
        
    }
    
}

// MARK: Delegate
extension GroupDetailViewController: UITableViewDelegate {
}

// MARK: DataSource
extension GroupDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "群組成員"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        classMembersNameArray.count // classMembersIDArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupDetailTableViewCell", for: indexPath) as? GroupDetailTableViewCell
        else {
            // 處理轉換失敗的情況，例如創建一個預設的 UITableViewCell
            return UITableViewCell()
        }
        
        cell.personIconBtn.setImage(UIImage(named: "person2.png"), for: .normal)
        cell.personNameLabel.text = self.classMembersNameArray[indexPath.row] // classMembersIDArray[indexPath.row]
        
        return cell
    }
}
