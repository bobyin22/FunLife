//
//  MyGroupListViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/23.
//

import UIKit
import FirebaseFirestore

// 4️⃣
class MyGroupListViewController: UIViewController {
    
    var text = ""
    let groupListTableView = UITableView()
    // var groupNameArray: [String] = [""]
    var userGroupArray: [String] = [""]
    var groupMembersArrays: [[String]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupGroupListTableView()
        groupListTableView.register(MyGroupListTableViewCell.self, forCellReuseIdentifier: "MyGroupListTableViewCell")
        groupListTableView.delegate = self
        groupListTableView.dataSource = self
        
        addGroup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAPI()
    }
    
    // MARK: 抓取firebase上的資料
    func fetchAPI() {
        userGroupArray.removeAll()
        
        let db = Firestore.firestore()
        
        db.collection("group").whereField("members", arrayContains: "\(UserDefaults.standard.string(forKey: "myUserID")!)") .getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            let userGroup = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: Group.self)
            }
            
            // MARK: 取得成員名稱 userGroupArray
            let documents = snapshot.documents
            var indexNumber = 0
            
            for document in documents {
                let data = document.data()
                guard let groupMembersArray = data["members"] as? [String] else { return }
                self.groupMembersArrays.append(groupMembersArray)
                indexNumber += 1
            }
            
            indexNumber = 0
            
            // MARK: 取得教室名稱 userGroupArray
            for index in userGroup {
                self.userGroupArray.append(userGroup[indexNumber].roomName)
//                self.groupMembersArrays.append(userGroup[indexNumber].members)
                indexNumber += 1
            }
            self.groupListTableView.reloadData()
        }
    }
    
    // MARK: 建立UI TableView
    func setupGroupListTableView() {
        view.addSubview(groupListTableView)
        // groupListTableView.backgroundColor = .systemYellow
        groupListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            groupListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            groupListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            groupListTableView.heightAnchor.constraint(equalToConstant: 430)
        ])
    }
    // MARK: 建立UI 方形按鈕
    func addGroup() {
        let addGroupBtn = UIButton()
        addGroupBtn.setImage(UIImage(named: "plus1.png"), for: .normal)
        view.addSubview(addGroupBtn)
        // addGroupBtn.backgroundColor = .yellow
        addGroupBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        
        addGroupBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addGroupBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            addGroupBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            addGroupBtn.heightAnchor.constraint(equalToConstant: 50),
            addGroupBtn.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: 點擊按鈕發生的事
    @objc func clickBtn() {
        let createGroupVC = CreateGroupViewController()
        navigationController?.pushViewController(createGroupVC, animated: true)
    }
}

// MARK: 寫入要做的事
extension MyGroupListViewController: UITableViewDelegate {
    
}

// MARK: 寫入資料
extension MyGroupListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "MyGroupListTableViewCell",
                                                        for: indexPath) as? MyGroupListTableViewCell
        else { return }
                
        let selectedGroupID = userGroupArray[indexPath.row]             // 获取所选群组的 ID 或其他信息
        let selectedGroupMembers = groupMembersArrays[indexPath.row]
        
        // MARK: 點擊進入各自的下一頁
        let groupDetailVC = GroupDetailViewController()
        groupDetailVC.groupID = selectedGroupID // 传递群组 ID 或其他信息给详情页
        //groupDetailVC.groupMembersArray = selectedGroupMembers
        navigationController?.pushViewController(groupDetailVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userGroupArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "MyGroupListTableViewCell",
                                                        for: indexPath) as? MyGroupListTableViewCell
        else {
            // 處理轉換失敗的情況，例如創建一個預設的 UITableViewCell
            return UITableViewCell()
        }
        
         cell.groupNameLabel.text = userGroupArray[indexPath.row]
        // cell.settingIcon.setImage(UIImage(systemName: settingIconArray[indexPath.row]), for: .normal)
        return cell
    }
    
}
