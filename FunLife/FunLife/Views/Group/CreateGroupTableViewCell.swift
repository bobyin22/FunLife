//
//  CreateGroupTableViewCell.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/23.
//

import UIKit

class CreateGroupTableViewCell: UITableViewCell {

    // MARK: cell裡面有輸入欄
    let createGroupTextField = UITextField()
    
    // MARK: 程式碼寫在這
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCreateGroupTextField()
    }
    
    // MARK: AutoLayout輸入欄
    func setupCreateGroupTextField () {
        createGroupTextField.placeholder = "請輸入群組名稱"
        createGroupTextField.backgroundColor = .systemGray2
        createGroupTextField.borderStyle = .roundedRect
        contentView.addSubview(createGroupTextField)
        createGroupTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createGroupTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            createGroupTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            createGroupTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            createGroupTextField.heightAnchor.constraint(equalToConstant: 50),
            // createGroupTextField.widthAnchor.constraint(equalToConstant: 100)
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
