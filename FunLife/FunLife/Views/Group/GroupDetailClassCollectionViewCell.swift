//
//  GroupDetailClassCollectionViewCell.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/7/8.
//

import UIKit

class GroupDetailClassCollectionViewCell: UICollectionViewCell {
    
    let personIconBtn = UIButton()      // 頭像
    let personNameLabel = UILabel()     // 姓名
    let personTimerLabel = UILabel()    // 秒數
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPersonIconBtn()
        setupPersonNameLabel()
        setupPersonTimerLabel()
        
//        // 建立一個 UIImageView
//        orderItemStatusImageView = UIImageView(frame: CGRect(x: 18, y: 0, width: 24, height: 24))
//        //orderItemStatusImageView.backgroundColor = .red
//        self.addSubview(orderItemStatusImageView)
//
//        // 建立一個 UILabel
//        orderItemStatusLabel.frame = CGRect(x: 0, y: 32, width: 58, height: 18)
//        //orderItemStatusLabel.sizeToFit()
//        orderItemStatusLabel.textAlignment = .center
//        orderItemStatusLabel.textColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
//
//
//        self.addSubview(orderItemStatusLabel)
        
    }
    
    
    func setupPersonIconBtn() {
        // personIconBtn.backgroundColor = .systemYellow
        personIconBtn.setImage(UIImage(named: "person2.png"), for: .normal)
        contentView.addSubview(personIconBtn)
        personIconBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            personIconBtn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            personIconBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            // personIconBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            personIconBtn.widthAnchor.constraint(equalToConstant: 50),
            personIconBtn.heightAnchor.constraint(equalToConstant: 50),
            personIconBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func setupPersonNameLabel() {
        // personNameLabel.backgroundColor = .systemMint
        personNameLabel.text = "人名"
        personNameLabel.textColor = .white
        contentView.addSubview(personNameLabel)
        personNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            personNameLabel.topAnchor.constraint(equalTo: personIconBtn.bottomAnchor, constant: 10),
            personNameLabel.leadingAnchor.constraint(equalTo: personIconBtn.leadingAnchor, constant: 0),
            // personNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            personNameLabel.widthAnchor.constraint(equalToConstant: 100),
            personNameLabel.heightAnchor.constraint(equalToConstant: 40),
            //personNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: AutoLayout Label秒數
    func setupPersonTimerLabel () {
        // personTimerLabel.backgroundColor = .systemCyan
        personTimerLabel.text = "秒數"
        personTimerLabel.textColor = .white
        contentView.addSubview(personTimerLabel)
        personTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            personTimerLabel.topAnchor.constraint(equalTo: personNameLabel.bottomAnchor, constant: 0),
            personTimerLabel.leadingAnchor.constraint(equalTo: personNameLabel.leadingAnchor, constant: 0),
            // personTimerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            personTimerLabel.widthAnchor.constraint(equalToConstant: 100),
            personTimerLabel.heightAnchor.constraint(equalToConstant: 40),
            //personTimerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
