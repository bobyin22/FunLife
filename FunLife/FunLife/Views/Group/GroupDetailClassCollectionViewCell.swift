//
//  GroupDetailClassCollectionViewCell.swift
//  FunLife
//
//  Created by 尹周舶 on 2023/7/8.
//

import UIKit

class GroupDetailClassCollectionViewCell: UICollectionViewCell {
    
    let personDeskIconBtn = UIButton()  // 書桌
    let personIconBtn = UIButton()      // 頭像
    let personNameLabel = UILabel()     // 姓名
    let personTimerLabel = UILabel()    // 秒數
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPersonDeskIconBtn()
        setupPersonIconBtn()
        setupPersonNameLabel()
        setupPersonTimerLabel()
    }
    
    func setupPersonDeskIconBtn() {
        personDeskIconBtn.setImage(UIImage(named: "ComputerDesk.png"), for: .normal)
        contentView.addSubview(personDeskIconBtn)
        personDeskIconBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            personDeskIconBtn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            personDeskIconBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -35),
            personDeskIconBtn.widthAnchor.constraint(equalToConstant: 115),
            personDeskIconBtn.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func setupPersonIconBtn() {
        personIconBtn.setImage(UIImage(named: "person.png"), for: .normal)
        personIconBtn.imageView?.contentMode = .scaleAspectFill
        contentView.addSubview(personIconBtn)
        personIconBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            personIconBtn.topAnchor.constraint(equalTo: personDeskIconBtn.bottomAnchor, constant: -40),
            personIconBtn.leadingAnchor.constraint(equalTo: personDeskIconBtn.leadingAnchor, constant: 34),
            personIconBtn.widthAnchor.constraint(equalToConstant: 50),
            personIconBtn.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        personIconBtn.layer.borderColor = UIColor(red: 136/255, green: 136/255, blue: 134/255, alpha: 1).cgColor
        personIconBtn.layer.borderWidth = 1.5

        // 圓半徑設為 寬的一半
        personIconBtn.layer.cornerRadius = 25
        // 確保圓形圖不顯示超出邊界的部分
        personIconBtn.clipsToBounds = true
        personIconBtn.layer.masksToBounds = true        // MARK: 讓照片變成圓形的
    }
    
    func setupPersonNameLabel() {
        personNameLabel.text = "人名"
        personNameLabel.textColor = .white
        contentView.addSubview(personNameLabel)
        personNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            personNameLabel.topAnchor.constraint(equalTo: personIconBtn.bottomAnchor, constant: 10),
            personNameLabel.leadingAnchor.constraint(equalTo: personIconBtn.leadingAnchor, constant: 0),
            personNameLabel.widthAnchor.constraint(equalToConstant: 100),
            personNameLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    // MARK: AutoLayout Label秒數
    func setupPersonTimerLabel () {
        personTimerLabel.text = "秒數"
        personTimerLabel.font = UIFont.systemFont(ofSize: 12)
        personTimerLabel.textColor = .white
        contentView.addSubview(personTimerLabel)
        personTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            personTimerLabel.topAnchor.constraint(equalTo: personNameLabel.bottomAnchor, constant: 0),
            personTimerLabel.leadingAnchor.constraint(equalTo: personNameLabel.leadingAnchor, constant: 0),
            personTimerLabel.widthAnchor.constraint(equalToConstant: 100),
            personTimerLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
