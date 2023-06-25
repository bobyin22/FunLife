//
//  ProfileView.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/25.
//

import UIKit

class ProfileView: UIView {

    // MARK: 建立一個UI 儲存按鈕
    let userTitleLabel: UILabel = {
        let userTitleLabel = UILabel()
        return userTitleLabel
    }()
    
    // MARK: 建立一個UI 儲存按鈕
    let saveProfileBtn: UIButton = {
        let saveProfileBtn = UIButton()
        return saveProfileBtn
    }()
    
    // MARK: 建立一個UI 輸入欄
    let profileNameTextField: UITextField = {
        let profileNameTextField = UITextField()
        return profileNameTextField
    }()
    
    
    // MARK: 初始init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUserTitleLabel()
        setupSaveProfileBtn()
        setupProfileNameTextField()
    }
    
    // MARK: 姓名Label AutoLayout
    func setupUserTitleLabel() {
        userTitleLabel.text = "姓名"
        addSubview(userTitleLabel)
        userTitleLabel.backgroundColor = .white
        
        userTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userTitleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            userTitleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            //userTitleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            userTitleLabel.widthAnchor.constraint(equalToConstant: 50),
            userTitleLabel.heightAnchor.constraint(equalToConstant: 50),
            //userTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }
    
    // MARK: 儲存按鈕 AutoLayout
    func setupSaveProfileBtn() {
        saveProfileBtn.setTitle("儲存", for: .normal)
        addSubview(saveProfileBtn)
        saveProfileBtn.backgroundColor = .systemBlue

        saveProfileBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveProfileBtn.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            //saveProfileBtn.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            saveProfileBtn.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            saveProfileBtn.widthAnchor.constraint(equalToConstant: 100),
            saveProfileBtn.heightAnchor.constraint(equalToConstant: 50),
            //saveProfileBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }
    
    // MARK: 輸入欄 AutoLayout
    func setupProfileNameTextField() {
        profileNameTextField.placeholder = "請輸入使用者姓名"
        profileNameTextField.clearButtonMode = .whileEditing
        profileNameTextField.borderStyle = .roundedRect
        profileNameTextField.backgroundColor = .systemGray2

        addSubview(profileNameTextField)
        profileNameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileNameTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            profileNameTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            profileNameTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            profileNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: 需要寫上
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
