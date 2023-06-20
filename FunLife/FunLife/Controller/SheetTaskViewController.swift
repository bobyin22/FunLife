//
//  SheetTaskViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/20.
//

import UIKit

class SheetTaskViewController: UIViewController {
    
    let myTaskTableView = UITableView()
    
    // MARK: 假資料圖
    let settingIconArray = ["doc.plaintext",
                            "doc.plaintext",
                            "doc.plaintext",
                            "doc.plaintext",
                            "doc.plaintext"]
    
    // MARK: 假資料任務
    let settingTitleArray = ["任務1", "任務2", "任務3", "任務4", "任務5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        myTaskTableView.register(SheetTaskTableViewCell.self, forCellReuseIdentifier: "SheetTaskTableViewCell")
        myTaskTableView.delegate = self
        myTaskTableView.dataSource = self
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(myTaskTableView)
        // myTaskTableView.backgroundColor = .blue
        myTaskTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myTaskTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            myTaskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            myTaskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            myTaskTableView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

extension SheetTaskViewController: UITableViewDelegate {
    
}

extension SheetTaskViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingIconArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SheetTaskTableViewCell", for: indexPath) as? SheetTaskTableViewCell
        else {
            // 處理轉換失敗的情況，例如創建一個預設的 UITableViewCell
            return UITableViewCell()
        }
        
        cell.settingIcon.setImage(UIImage(systemName: settingIconArray[indexPath.row]), for: .normal)
        cell.settingInfo.text = settingTitleArray[indexPath.row]
        
        return cell
    }
    
}
