//
//  MyGroupListViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/23.
//

import UIKit
import FirebaseFirestore

// 4️⃣
class MyGroupListViewController: UIViewController, CreateGroupViewControllerDelegate {
    
    var text = ""
    let groupListTableView = UITableView()
    // var groupNameArray: [String] = [""]
    var userGroupArray:[String] = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray2
        
        setupGroupListTableView()
        groupListTableView.register(MyGroupListTableViewCell.self, forCellReuseIdentifier: "MyGroupListTableViewCell")
        groupListTableView.delegate = self
        groupListTableView.dataSource = self
        
        addGroup()
        fetchAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: 抓取firebase上的資料
    func fetchAPI() {
        userGroupArray.removeAll()
        let db = Firestore.firestore()
        db.collection("group").getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            let userGroup = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: Group.self)
            }
            
            var indexNumber = 0
            for index in userGroup {
                self.userGroupArray.append(userGroup[indexNumber].roomName)
                indexNumber += 1
            }
            print(userGroup)
            self.groupListTableView.reloadData()
        }
    }
    
    // MARK: 建立UI TableView
    func setupGroupListTableView() {
        view.addSubview(groupListTableView)
        groupListTableView.backgroundColor = .systemYellow
        groupListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            groupListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            groupListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            groupListTableView.heightAnchor.constraint(equalToConstant: 450)
        ])
    }
    // MARK: 建立UI 方形按鈕
    func addGroup() {
        let addGroupBtn = UIButton()
        view.addSubview(addGroupBtn)
        addGroupBtn.backgroundColor = .yellow
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
        // 5️⃣
        let createGroupVC = CreateGroupViewController()
        navigationController?.pushViewController(createGroupVC, animated: true)
        
        // 6️⃣
        createGroupVC.delegate = self
    }
    
    // 7️⃣
    func passValue(parameter: String) {
        text = "\(parameter)"
        print("text是", text)
        
        guard let cell = groupListTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MyGroupListTableViewCell else {
            return
        }
        
        cell.groupNameLabel.text = text
        groupListTableView.reloadData()
    }
}

// MARK: 寫入要做的事
extension MyGroupListViewController: UITableViewDelegate {
    
}

// MARK: 寫入資料
extension MyGroupListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
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
