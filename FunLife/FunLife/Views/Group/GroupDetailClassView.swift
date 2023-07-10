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
        return inviteGroupBtn
    }()
    
    // MARK: 落地窗ImageView
    let classWindowImgaeView: UIImageView = {
        let windowImgaeView = UIImageView()
        return windowImgaeView
    }()
    
    // MARK: 初始init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGroupDetailNameLabel()
        setupInviteGroupBtn()
        setupClassWindowImgaeView()

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
        inviteGroupBtn.setTitleColor(UIColor(red: 233/255, green: 227/255, blue: 217/255, alpha: 1), for: .normal)
        inviteGroupBtn.backgroundColor = UIColor(red: 81/255, green: 88/255, blue: 104/255, alpha: 1)
        inviteGroupBtn.layer.borderColor = UIColor(red: 186/255, green: 129/255, blue: 71/255, alpha: 1).cgColor
        inviteGroupBtn.layer.borderWidth = 2.0

        addSubview(inviteGroupBtn)
        inviteGroupBtn.clipsToBounds = true
        inviteGroupBtn.layer.cornerRadius = 8
        inviteGroupBtn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20) // 调整上下左右内边距
        
        inviteGroupBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inviteGroupBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            // inviteGroupBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            inviteGroupBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            inviteGroupBtn.widthAnchor.constraint(equalToConstant: 90),
            inviteGroupBtn.heightAnchor.constraint(equalToConstant: 40),
            // inviteGroupBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }
    
    // MARK: 落地窗ImageView AutoLayout
    func setupClassWindowImgaeView() {
        classWindowImgaeView.image = UIImage(named: "ClassWindow.png")
        addSubview(classWindowImgaeView)
        classWindowImgaeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            classWindowImgaeView.topAnchor.constraint(equalTo: inviteGroupBtn.bottomAnchor, constant: 10),
            classWindowImgaeView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            classWindowImgaeView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            classWindowImgaeView.heightAnchor.constraint(equalToConstant: 100),
            // classWindowImgaeView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }
    
    // MARK: 需要寫上
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
