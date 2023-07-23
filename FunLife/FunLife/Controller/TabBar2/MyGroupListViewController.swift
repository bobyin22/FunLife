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
    
    let firebaseManager = FirebaseManager()
    
    // MARK: 點擊進入各自的下一頁
    let groupDetailClassVC = GroupDetailClassViewController()                       // MARK: 🍀新collection改從這進入
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // view.backgroundColor = .white
        setupGroupListTableView()
        setupAddGroupBtn()
        
        groupListTableView.register(MyGroupListTableViewCell.self, forCellReuseIdentifier: "MyGroupListTableViewCell")
        groupListTableView.delegate = self
        groupListTableView.dataSource = self
        navbarAndtabbarsetup()
        
        firebaseManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseManager.fetchGroupListAPI()
        self.groupListTableView.reloadData()
        
        groupDetailClassVC.fetchClassID = ""
    }
    
    // MARK: 設定nav tab 底色與字顏色
    func navbarAndtabbarsetup() {
        // 設置 NavigationBar 的外觀
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    
        tabBarController?.tabBar.barTintColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
        tabBarController?.tabBar.shadowImage = UIImage()
        tabBarController?.tabBar.isTranslucent = false
    }
        
    // MARK: 建立UI TableView
    func setupGroupListTableView() {
        view.addSubview(groupListTableView)
        groupListTableView.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        groupListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupListTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),  // view.safeAreaLayoutGuide.topAnchor
            groupListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            groupListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            groupListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            // groupListTableView.heightAnchor.constraint(equalToConstant: 430)
        ])
        groupListTableView.separatorStyle = .none

    }
    // MARK: 建立UI 方形按鈕
    func setupAddGroupBtn() {
        let addGroupBtn = UIButton()
        addGroupBtn.setImage(UIImage(named: "plus3.png"), for: .normal)
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
    
    // MARK: 點擊按鈕發生的事   建立群組頁
    @objc func clickBtn() {
        let createGroupVC = CreateGroupViewController()
        navigationController?.pushViewController(createGroupVC, animated: true)
    }
    
    // 提示框
    func alertMsg () {
        let alert = UIAlertController(title: "個人頁面資料不完整", message: "填上你的姓名、照片，讓好友知道你", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
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
        
        let selectedGroupID = firebaseManager.userInGroupClassNameArray[indexPath.row]             // MARK: 獲取 使用者教室名稱，要讓下一頁Label顯示教室名稱
        
        // 如果firebase image && name 有值，通知
        let db = Firestore.firestore()
        db.collection("users").document(UserDefaults.standard.string(forKey: "myUserID")!).getDocument() { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            // 如果裡面有url載入
            // 如果沒有url，不做事
            if snapshot.data()!["image"] == nil || snapshot.data()!["name"] == nil {
                // return
                self.alertMsg()
            } else {
                self.groupDetailClassVC.classNameString = selectedGroupID                            // MARK: 獲取 使用者教室名稱，要讓下一頁Label顯示教室名稱
                self.groupDetailClassVC.fetchClassID = self.firebaseManager.userInGroupIDNameArray[indexPath.row]
                print("🎃indexPath.row是", indexPath.row)
                print("🎉self.userInGroupIDNameArray[indexPath.row]是", self.groupDetailClassVC.fetchClassID, self.firebaseManager.userInGroupIDNameArray[indexPath.row])
                self.navigationController?.pushViewController(self.groupDetailClassVC, animated: true)
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        firebaseManager.userInGroupClassNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "MyGroupListTableViewCell",
                                                        for: indexPath) as? MyGroupListTableViewCell
        else {
            // 處理轉換失敗的情況，例如創建一個預設的 UITableViewCell
            return UITableViewCell()
        }
        
        cell.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 38/255)
        cell.groupNameLabel.text = firebaseManager.userInGroupClassNameArray[indexPath.row]   // List的教室名稱🍀
        // cell.settingIcon.setImage(UIImage(systemName: settingIconArray[indexPath.row]), for: .normal)
        return cell
    }
    
}

extension MyGroupListViewController: FirebaseManagerDelegate {
    func renderText() {}
    
    
    func kfRenderImg() {}
    
    // 設定tableView資料源後調用的方法
        func reloadData() {
            groupListTableView.reloadData()
        }
}
