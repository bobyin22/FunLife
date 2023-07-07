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
        // groupDetailImageView.backgroundColor = .white //. systemBlue
        return groupDetailImageView
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
        //groupDetailNameLabel.backgroundColor = .systemBlue
        return groupDetailNameLabel
    }()
    
    // MARK: 初始init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGroupDetailNameLabel()
        setupGroupDetailImageView()
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
            //groupDetailNameLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 150),
        ])
    }
    
    // MARK: 照片AutoLayout
    func setupGroupDetailImageView() {
        groupDetailImageView.image = UIImage(named: "StudyRoom3")
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
