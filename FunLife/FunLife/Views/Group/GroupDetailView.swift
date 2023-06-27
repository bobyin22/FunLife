//
//  GroupDetailView.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/24.
//

import UIKit

class GroupDetailView: UIView {

    var passData = ""
    
    // MARK: 建立一個UI 照片
    let groupDetailImageView: UIImageView = {
        let groupDetailImageView = UIImageView()
        groupDetailImageView.backgroundColor = .white //. systemBlue
        return groupDetailImageView
    }()
        
    // MARK: 建立一個UI TableView
    let groupDetailTableView: UITableView = {
        let groupDetailTableView = UITableView()
        groupDetailTableView.backgroundColor = .systemGreen
        return groupDetailTableView
    }()
    
    // MARK: 左進入按鈕
    let goGroupBtn: UIButton = {
        let goGroupBtn = UIButton()
        goGroupBtn.backgroundColor = .systemBlue
        return goGroupBtn
    }()
    
    // MARK: 右邀請朋友按鈕
    let inviteGroupBtn: UIButton = {
        let inviteGroupBtn = UIButton()
        inviteGroupBtn.backgroundColor = .systemBlue
        return inviteGroupBtn
    }()
    
    // MARK: 教室名稱
    let groupDetailNameLabel: UILabel = {
        let groupDetailNameLabel = UILabel()
        groupDetailNameLabel.backgroundColor = .systemBlue
        return groupDetailNameLabel
    }()
    
    // MARK: 初始init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGroupDetailNameLabel()
        setupGroupDetailImageView()
        setupGroupDetailTableView()
        
        groupDetailTableView.register(GroupDetailTableViewCell.self, forCellReuseIdentifier: "GroupDetailTableViewCell")
        groupDetailTableView.delegate = self
        groupDetailTableView.dataSource = self
        
        setupGoGroupBtn()
        setupInviteGroupBtn()
    }
    
    // MARK: 教室名Label AutoLayout
    func setupGroupDetailNameLabel() {
        groupDetailNameLabel.text = "包伯的教室"
        addSubview(groupDetailNameLabel)
        groupDetailNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupDetailNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            groupDetailNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            // groupDetailNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            groupDetailNameLabel.widthAnchor.constraint(equalToConstant: 100),
            groupDetailNameLabel.heightAnchor.constraint(equalToConstant: 50),
            //groupDetailNameLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 150),
        ])
    }
    
    // MARK: 照片AutoLayout
    func setupGroupDetailImageView() {
        groupDetailImageView.image = UIImage(named: "StudyRoom1")
        groupDetailImageView.contentMode = .scaleAspectFit
        addSubview(groupDetailImageView)
        groupDetailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupDetailImageView.topAnchor.constraint(equalTo: groupDetailNameLabel.bottomAnchor, constant: 10),
            groupDetailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            groupDetailImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            //groupDetailImageView.widthAnchor.constraint(equalToConstant: 150),
            groupDetailImageView.heightAnchor.constraint(equalToConstant: 120),
            //groupDetailImageView.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 150),
        ])
    }
    
    // MARK: 建立群組tablview的AutoLayout
    func setupGroupDetailTableView() {
        addSubview(groupDetailTableView)
        groupDetailTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupDetailTableView.topAnchor.constraint(equalTo: groupDetailImageView.bottomAnchor, constant: 30),
            groupDetailTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            groupDetailTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            groupDetailTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100),
        ])
    }
    
    // MARK: 進入房間按鈕AutoLayout
    func setupGoGroupBtn() {
        goGroupBtn.setTitle("進入", for: .normal)
        addSubview(goGroupBtn)
        goGroupBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goGroupBtn.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            goGroupBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            //goGroupBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -200),
            goGroupBtn.widthAnchor.constraint(equalToConstant: 150),
            goGroupBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }
    
    // MARK: 邀請按鈕AutoLayout
    func setupInviteGroupBtn() {
        inviteGroupBtn.setTitle("邀請", for: .normal)
        addSubview(inviteGroupBtn)
        inviteGroupBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inviteGroupBtn.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            // inviteGroupBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            inviteGroupBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            inviteGroupBtn.widthAnchor.constraint(equalToConstant: 150),
            inviteGroupBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }
      
    // MARK: 需要寫上
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GroupDetailView: UITableViewDelegate {
    
}

extension GroupDetailView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "群組成員"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupDetailTableViewCell", for: indexPath) as? GroupDetailTableViewCell
        else {
            // 處理轉換失敗的情況，例如創建一個預設的 UITableViewCell
            return UITableViewCell()
        }
        
        cell.personIconBtn.setImage(UIImage(named: "person2.png"), for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
            print("傳過來的passData",self.passData)
            cell.personNameLabel.text = self.passData
        }

        return cell
    }
    
}
