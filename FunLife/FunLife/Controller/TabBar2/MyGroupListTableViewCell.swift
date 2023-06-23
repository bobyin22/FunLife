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
    
    // MARK: 程式碼寫在這
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupGroupNameLabel()
        setupGroupPhotoImageView()
    }
     
    func setupGroupNameLabel () {
        groupNameLabel.text = "Bob的群組"
        groupNameLabel.backgroundColor = .systemBlue
        contentView.addSubview(groupNameLabel)
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            groupNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            groupNameLabel.heightAnchor.constraint(equalToConstant: 50),
            groupNameLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupGroupPhotoImageView () {
        groupPhotoImageView.image = UIImage(named: "StudyRoom.jpeg")
        groupPhotoImageView.contentMode = .scaleAspectFit
        groupPhotoImageView.backgroundColor = .systemGreen
        contentView.addSubview(groupPhotoImageView)
        groupPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupPhotoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            groupPhotoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            groupPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            groupPhotoImageView.widthAnchor.constraint(equalToConstant: 100)
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
