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
    
    func addGroup() {
        let addGroupBtn = UIButton()
        view.addSubview(addGroupBtn)
        addGroupBtn.backgroundColor = .yellow
        addGroupBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        
        addGroupBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addGroupBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
            addGroupBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            addGroupBtn.heightAnchor.constraint(equalToConstant: 50),
            addGroupBtn.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func clickBtn() {
        let createGroupVC = CreateGroupViewController()
        navigationController?.pushViewController(createGroupVC, animated: true)
    }
}

extension MyGroupListViewController: UITableViewDelegate {
    
}

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
