//
//  SheetTaskTableViewCell.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/20.
//

import UIKit

class SheetTaskTableViewCell: UITableViewCell {

    var settingIcon = UIButton()    // MARK: UI圖示
    var settingInfo = UILabel()     // MARK: UI文字
    
    // MARK: 程式碼寫在這
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSettingIcon()
        setupSettingInfo()
    }
    
    // MARK: 建立照片
    func setupSettingIcon() {
        contentView.addSubview(settingIcon)
        settingIcon.setImage(UIImage(systemName: "doc.plaintext"), for: .normal)
        settingIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            settingIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            settingIcon.heightAnchor.constraint(equalToConstant: 50),
            settingIcon.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: 建立任務
    func setupSettingInfo() {
        contentView.addSubview(settingInfo)
        settingInfo.text = "XXX"
        settingInfo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingInfo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            settingInfo.leadingAnchor.constraint(equalTo: settingIcon.trailingAnchor, constant: 20),
            settingInfo.heightAnchor.constraint(equalToConstant: 30),
            settingInfo.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    
    // MARK: 需要寫上
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
