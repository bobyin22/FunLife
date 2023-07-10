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
        // createGroupTableView.backgroundColor = .systemGreen
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
        cancelGroupBtn.backgroundColor = UIColor(red: 186/255, green: 129/255, blue: 71/255, alpha: 1)
        cancelGroupBtn.clipsToBounds = true
        cancelGroupBtn.layer.cornerRadius = 8
        cancelGroupBtn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20) // 调整上下左右内边距
        cancelGroupBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelGroupBtn.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -80),
            cancelGroupBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            //cancelGroupBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -200),
            cancelGroupBtn.widthAnchor.constraint(equalToConstant: 150),
            cancelGroupBtn.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // MARK: 新增按鈕AutoLayout
    func setupSaveGroupBtn() {
        saveGroupBtn.setTitle("建立", for: .normal)
        addSubview(saveGroupBtn)
        saveGroupBtn.backgroundColor = UIColor(red: 186/255, green: 129/255, blue: 71/255, alpha: 1)
        saveGroupBtn.clipsToBounds = true
        saveGroupBtn.layer.cornerRadius = 8
        saveGroupBtn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20) // 调整上下左右内边距
        saveGroupBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveGroupBtn.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -80),
            // saveGroupBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            saveGroupBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            saveGroupBtn.widthAnchor.constraint(equalToConstant: 150),
            saveGroupBtn.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // MARK: 建立群組tablview的AutoLayout
    func setupCreateGroupTableView() {
        addSubview(createGroupTableView)
        createGroupTableView.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
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
    
    // 分组头即将要显示
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.orange
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        //header.textLabel?.frame = header.frame
        header.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        // 設定左邊距約束
        let leadingConstraint = header.textLabel?.leadingAnchor.constraint(equalTo: header.contentView.leadingAnchor, constant: 10)
        leadingConstraint?.isActive = true
        // header.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            header.contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            header.contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            header.contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            //myTableView.heightAnchor.constraint(equalToConstant: 300)
        ])
        //header.textLabel?.backgroundColor = .blue
        header.textLabel?.textAlignment = .left
    }
    
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
        
        cell.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 38/255)
        cell.createGroupTextField.placeholder = "輸入輸入"
        // cell.settingIcon.setImage(UIImage(systemName: settingIconArray[indexPath.row]), for: .normal)
        return cell
    }

}
