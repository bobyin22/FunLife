//
//  GroupDetailTableViewCell.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/24.
//

import UIKit

class GroupDetailTableViewCell: UITableViewCell {

    let personIconBtn = UIButton()      // 頭像
    let personNameLabel = UILabel()     // 姓名
    let personTimerLabel = UILabel()    // 秒數
    
    // MARK: 程式碼寫在這
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupPersonIconBtn()
        setupPersonNameLabel()
        setupPersonTimerLabel()
    }
        
    // MARK: AutoLayout 按鈕照片
    func setupPersonIconBtn () {
        personIconBtn.backgroundColor = .systemYellow
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
    
    // MARK: AutoLayout Label名字
    func setupPersonNameLabel () {
        personNameLabel.backgroundColor = .systemMint
        personNameLabel.text = "載入人名"
        contentView.addSubview(personNameLabel)
        personNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            personNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            personNameLabel.leadingAnchor.constraint(equalTo: personIconBtn.trailingAnchor, constant: 50),
            // personNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            personNameLabel.widthAnchor.constraint(equalToConstant: 100),
            personNameLabel.heightAnchor.constraint(equalToConstant: 50),
            personNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: AutoLayout Label秒數
    func setupPersonTimerLabel () {
        personTimerLabel.backgroundColor = .systemCyan
        personTimerLabel.text = "載入秒數"
        contentView.addSubview(personTimerLabel)
        personTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            personTimerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            personTimerLabel.leadingAnchor.constraint(equalTo: personNameLabel.trailingAnchor, constant: 50),
            // personTimerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            personTimerLabel.widthAnchor.constraint(equalToConstant: 100),
            personTimerLabel.heightAnchor.constraint(equalToConstant: 50),
            personTimerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: 必需要寫上
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
