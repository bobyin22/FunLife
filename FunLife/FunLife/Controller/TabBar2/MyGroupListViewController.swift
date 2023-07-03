//
//  MyGroupListViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/23.
//

import UIKit
import FirebaseFirestore

class MyGroupListViewController: UIViewController {
    
    let groupListTableView = UITableView()
    var userInGroupClassNameArray: [String] = []      // 用來存教室名稱 ["教室1", "教室2"]
    // var groupMembersArrays: [[String]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupGroupListTableView()
        setupAddGroupBtn()
        
        groupListTableView.register(MyGroupListTableViewCell.self, forCellReuseIdentifier: "MyGroupListTableViewCell")
        groupListTableView.delegate = self
        groupListTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAPI()
    }
    
    // MARK: 抓取firebase上的資料
    func fetchAPI() {
        
        let db = Firestore.firestore()
        
        // MARK: group下document，且 members欄是使用者，才顯示教室
        db.collection("group").whereField("members", arrayContains: "\(UserDefaults.standard.string(forKey: "myUserID")!)").addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            let userGroup = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: Group.self)
            }
            
            var indexNumber = 0
            
            self.userInGroupClassNameArray.removeAll()
            // MARK: 取得教室名稱 userGroupArray
            for index in userGroup {
                self.userInGroupClassNameArray.append(userGroup[indexNumber].roomName)
                print("userGroupArray", self.userInGroupClassNameArray)
                indexNumber += 1
            }
            self.groupListTableView.reloadData()
        }
    }
    
    // MARK: 建立UI TableView
    func setupGroupListTableView() {
        view.addSubview(groupListTableView)
        groupListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            groupListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            groupListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            groupListTableView.heightAnchor.constraint(equalToConstant: 430)
        ])
    }
    // MARK: 建立UI 方形按鈕
    func setupAddGroupBtn() {
        let addGroupBtn = UIButton()
        addGroupBtn.setImage(UIImage(named: "plus1.png"), for: .normal)
        view.addSubview(addGroupBtn)
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
                
        let selectedGroupID = userInGroupClassNameArray[indexPath.row]             // MARK: 獲取 使用者教室名稱，要讓下一頁Label顯示教室名稱
        
        // MARK: 點擊進入各自的下一頁
        let groupDetailVC = GroupDetailViewController()
        groupDetailVC.classNameString = selectedGroupID                            // MARK: 獲取 使用者教室名稱，要讓下一頁Label顯示教室名稱
        navigationController?.pushViewController(groupDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userInGroupClassNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "MyGroupListTableViewCell",
                                                        for: indexPath) as? MyGroupListTableViewCell
        else {
            // 處理轉換失敗的情況，例如創建一個預設的 UITableViewCell
            return UITableViewCell()
        }
        
        cell.groupNameLabel.text = userInGroupClassNameArray[indexPath.row]   // List的教室名稱🍀
        // cell.settingIcon.setImage(UIImage(systemName: settingIconArray[indexPath.row]), for: .normal)
        return cell
    }
    
}
