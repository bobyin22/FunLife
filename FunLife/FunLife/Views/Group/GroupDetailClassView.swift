//
//  GroupDetailClassView.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/7/7.
//

import UIKit

class GroupDetailClassView: UIView {

    // MARK: 教室名稱
    let groupDetailNameLabel: UILabel = {
        let groupDetailNameLabel = UILabel()
        // groupDetailNameLabel.backgroundColor = .systemBlue
        return groupDetailNameLabel
    }()
        
    // MARK: 右邀請朋友按鈕
    let inviteGroupBtn: UIButton = {
        let inviteGroupBtn = UIButton()
        inviteGroupBtn.backgroundColor = .systemBlue
        return inviteGroupBtn
    }()
    
    // MARK: 初始init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGroupDetailNameLabel()
        setupInviteGroupBtn()
    }

    // MARK: 教室名Label AutoLayout
    func setupGroupDetailNameLabel() {
        groupDetailNameLabel.text = "xx教室"
        groupDetailNameLabel.textColor = .white
        addSubview(groupDetailNameLabel)
        groupDetailNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupDetailNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            groupDetailNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            // groupDetailNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            groupDetailNameLabel.widthAnchor.constraint(equalToConstant: 100),
            groupDetailNameLabel.heightAnchor.constraint(equalToConstant: 50),
            // groupDetailNameLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 150),
        ])
    }
    
    // MARK: 邀請按鈕AutoLayout
    func setupInviteGroupBtn() {
        inviteGroupBtn.setTitle("邀請", for: .normal)
        inviteGroupBtn.setTitleColor(.black, for: .normal)
        addSubview(inviteGroupBtn)
        inviteGroupBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inviteGroupBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            // inviteGroupBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            inviteGroupBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            inviteGroupBtn.widthAnchor.constraint(equalToConstant: 100),
            inviteGroupBtn.heightAnchor.constraint(equalToConstant: 50),
            // inviteGroupBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }
    
    // MARK: 需要寫上
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
