//
//  ProfileView.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/25.
//

import UIKit

class ProfileView: UIView {
    
    // MARK: 建立一個UI 使用者頭貼照片
    let profilePhotoImageView: UIImageView = {
        let profilePhotoImageView = UIImageView()
        return profilePhotoImageView
    }()
    
    // MARK: 建立一個UI 相機按鈕
    let profileCaeraBtn: UIButton = {
        let profileCaeraBtn = UIButton()
        return profileCaeraBtn
    }()
    
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
        setupPhotoImageView()
        setupCameraBtn()
        setupUserTitleLabel()
        setupSaveProfileBtn()
        setupProfileNameTextField()
    }
    
    // MARK: 照片Image AutoLayout
    func setupPhotoImageView() {
        profilePhotoImageView.image = UIImage(named: "person2")
        
        profilePhotoImageView.contentMode = .scaleAspectFill
        
        profilePhotoImageView.backgroundColor = .systemYellow
        addSubview(profilePhotoImageView)
        profilePhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profilePhotoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            profilePhotoImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: -78),
            profilePhotoImageView.heightAnchor.constraint(equalToConstant: 150),
            profilePhotoImageView.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        profilePhotoImageView.layer.borderColor = UIColor.black.cgColor
        profilePhotoImageView.layer.borderWidth = 2.0

        // 圓半徑設為 寬的一半
        profilePhotoImageView.layer.cornerRadius = 75
        // 確保圓形圖不顯示超出邊界的部分
        profilePhotoImageView.clipsToBounds = true
        profilePhotoImageView.layer.masksToBounds = true        // MARK: 讓照片變成圓形的
    }
    
    // MARK: 照相Button AutoLayout
    func setupCameraBtn() {
        profileCaeraBtn.setImage(UIImage(named: "camera1"), for: .normal)
        //profileCaeraBtn.backgroundColor = .systemMint
        addSubview(profileCaeraBtn)
        profileCaeraBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileCaeraBtn.topAnchor.constraint(equalTo: profilePhotoImageView.bottomAnchor, constant: -30),
            profileCaeraBtn.leadingAnchor.constraint(equalTo: profilePhotoImageView.trailingAnchor, constant: 10),
            //profileCaeraBtn.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            profileCaeraBtn.widthAnchor.constraint(equalToConstant: 30),
            profileCaeraBtn.heightAnchor.constraint(equalToConstant: 30),
            //profileCaeraBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }
    
    // MARK: 姓名Label AutoLayout
    func setupUserTitleLabel() {
        userTitleLabel.text = "姓名"
        userTitleLabel.textColor = .white
        addSubview(userTitleLabel)
        //userTitleLabel.backgroundColor = .white
        
        userTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userTitleLabel.topAnchor.constraint(equalTo: profilePhotoImageView.bottomAnchor, constant: 25),
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
            saveProfileBtn.topAnchor.constraint(equalTo: profilePhotoImageView.bottomAnchor, constant: 25),
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
            profileNameTextField.topAnchor.constraint(equalTo: userTitleLabel.bottomAnchor, constant: 20),
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
