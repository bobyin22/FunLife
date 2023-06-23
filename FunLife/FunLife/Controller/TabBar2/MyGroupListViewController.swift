//
//  MyGroupListViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/23.
//

import UIKit

class MyGroupListViewController: UIViewController {
    
    let groupListTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray2
        
        setupGroupListTableView()
        groupListTableView.register(MyGroupListTableViewCell.self, forCellReuseIdentifier: "MyGroupListTableViewCell")
        groupListTableView.delegate = self
        groupListTableView.dataSource = self
        
        addGroup()
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
            groupListTableView.heightAnchor.constraint(equalToConstant: 300)
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
        let createGroupVC = CreateGroupViewController()
        navigationController?.pushViewController(createGroupVC, animated: true)
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
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "MyGroupListTableViewCell",
                                                        for: indexPath) as? MyGroupListTableViewCell
        else {
            // 處理轉換失敗的情況，例如創建一個預設的 UITableViewCell
            return UITableViewCell()
        }
        
        cell.groupNameLabel.text = "Bob的群組"
        // cell.settingIcon.setImage(UIImage(systemName: settingIconArray[indexPath.row]), for: .normal)
        return cell
    }
    
}
