//
//  MyGroupListTableViewCell.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/23.
//

import UIKit

class MyGroupListTableViewCell: UITableViewCell {

    let groupNameLabel = UILabel()
    let groupPhotoImageView = UIImageView()
    let groupOutsideView = UIView()
    
    // MARK: 程式碼寫在這
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupGroupNameLabel()
        setupGroupPhotoImageView()
        setupGroupOutsideView()
    }
    
    func setupGroupOutsideView() {
            contentView.addSubview(groupOutsideView)
            groupOutsideView.translatesAutoresizingMaskIntoConstraints = false
            groupOutsideView.layer.cornerRadius = 20    // 設定圓角半徑
            groupOutsideView.layer.borderWidth = 1      // 設定邊框寬度
            groupOutsideView.layer.borderColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1).cgColor
            groupOutsideView.clipsToBounds = true       // 裁剪超出範圍的內容
            NSLayoutConstraint.activate([
                groupOutsideView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                groupOutsideView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                groupOutsideView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                groupOutsideView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
        }
     
    func setupGroupNameLabel () {
        groupNameLabel.text = " "
        groupNameLabel.textColor = .white
        contentView.addSubview(groupNameLabel)
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            groupNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            groupNameLabel.heightAnchor.constraint(equalToConstant: 50),
            groupNameLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupGroupPhotoImageView () {
        groupPhotoImageView.image = UIImage(named: "StudyRoom")
        groupPhotoImageView.contentMode = .scaleToFill
        groupPhotoImageView.layer.cornerRadius = 20     // 設定圓角半徑
        groupPhotoImageView.clipsToBounds = true        // 裁剪超出範圍的內容
        contentView.addSubview(groupPhotoImageView)
        groupPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupPhotoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            groupPhotoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            groupPhotoImageView.widthAnchor.constraint(equalToConstant: 190),
            groupPhotoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
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
