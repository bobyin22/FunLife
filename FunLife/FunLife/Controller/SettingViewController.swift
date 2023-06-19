//
//  SettingViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/16.
//

import UIKit

class SettingViewController: UIViewController {

    let myTableView = UITableView()
    let settingIconArray = ["person", "link", "phone.bubble.left.fill", "music.note", "network"]    // MARK: 設定頁的圖像
    let settingTitleArray = ["管理我的資訊", "邀請朋友", "震動", "鈴聲", "登出"]                          // MARK: 設定頁的內容
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray3
        
        setupMyTableView()
        myTableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.rowHeight = UITableView.automaticDimension
        myTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func setupMyTableView() {
        view.addSubview(myTableView)
        myTableView.backgroundColor = .systemGreen
        myTableView.backgroundColor = .systemYellow
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            myTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            myTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            myTableView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
}

extension SettingViewController: UITableViewDelegate {
    
}

extension SettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell",
                                                        for: indexPath) as? SettingTableViewCell
        else {
            // 處理轉換失敗的情況，例如創建一個預設的 UITableViewCell
            return UITableViewCell()
        }
        
        cell.settingIcon.setImage(UIImage(systemName: settingIconArray[indexPath.row]), for: .normal)
        cell.settingInfo.text = settingTitleArray[indexPath.row]
        
        return cell
    }
}
