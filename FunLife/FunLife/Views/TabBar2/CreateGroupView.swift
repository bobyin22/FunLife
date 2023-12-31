//
//  CreateGroupView.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/23.
//

import UIKit



class CreateGroupView: UIView {
    
    // MARK: 建立一個UI TableView
    let createGroupTableView: UITableView = {
        let createGroupTableView = UITableView()
        createGroupTableView.backgroundColor = .systemGreen
        return createGroupTableView
    }()
    
    // MARK: 建立一個UI 儲存按鈕
    let saveGroupBtn: UIButton = {
        let saveGroupBtn = UIButton()
        saveGroupBtn.backgroundColor = .systemBlue
        return saveGroupBtn
    }()
    
    // MARK: 建立一個UI 取消按鈕
    let cancelGroupBtn: UIButton = {
        let cancelGroupBtn = UIButton()
        cancelGroupBtn.backgroundColor = .systemBlue
        return cancelGroupBtn
    }()

    // MARK: 初始init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createGroupTableView.register(CreateGroupTableViewCell.self, forCellReuseIdentifier: "CreateGroupTableViewCell")
        createGroupTableView.delegate = self
        createGroupTableView.dataSource = self
        
        setupCreateGroupTableView()
        setupCancelGroupBtn()
        setupSaveGroupBtn()
    }
    
    // MARK: 取消按鈕AutoLayout
    func setupCancelGroupBtn() {
        cancelGroupBtn.setTitle("取消", for: .normal)
        addSubview(cancelGroupBtn)
        cancelGroupBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelGroupBtn.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            cancelGroupBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            //cancelGroupBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -200),
            cancelGroupBtn.widthAnchor.constraint(equalToConstant: 150),
            cancelGroupBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }
    
    // MARK: 新增按鈕AutoLayout
    func setupSaveGroupBtn() {
        saveGroupBtn.setTitle("建立", for: .normal)
        addSubview(saveGroupBtn)
        saveGroupBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveGroupBtn.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            // saveGroupBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            saveGroupBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            saveGroupBtn.widthAnchor.constraint(equalToConstant: 150),
            saveGroupBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }
    
    // MARK: 建立群組tablview的AutoLayout
    func setupCreateGroupTableView() {
        addSubview(createGroupTableView)
        // 設定View的邊界
        createGroupTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            createGroupTableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            createGroupTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            createGroupTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            createGroupTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
        
    }
    
    // MARK: 需要寫上
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: 寫入TableView執行動作
extension CreateGroupView: UITableViewDelegate {
    
}

// MARK: 寫入TableView資料
extension CreateGroupView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "群組名稱"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CreateGroupTableViewCell", for: indexPath) as? CreateGroupTableViewCell
        else {
            // 處理轉換失敗的情況，例如創建一個預設的 UITableViewCell
            return UITableViewCell()
        }
        
        cell.createGroupTextField.placeholder = "輸入輸入"
        // cell.settingIcon.setImage(UIImage(systemName: settingIconArray[indexPath.row]), for: .normal)
        return cell
    }

}
