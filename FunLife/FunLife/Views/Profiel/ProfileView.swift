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
    let profileCameraBtn: UIButton = {
        let profileCameraBtn = UIButton()
        return profileCameraBtn
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let arcHeight: CGFloat = 50 // 半弧形的高度
        let aDegree = CGFloat.pi / 180
        let myPath = UIBezierPath(arcCenter: CGPoint(x: bounds.width/2, y: 00), radius: 330, startAngle: aDegree * 0, endAngle: aDegree * 180, clockwise: true)
        let myArcLayer = CAShapeLayer()
        myArcLayer.path = myPath.cgPath
        
        // 設置半弧形的樣式
        myArcLayer.fillColor = UIColor(red: 185/255, green: 131/255, blue: 69/255, alpha: 1).cgColor // 设置填充颜色
        
        // 半弧形的圖層添加到視圖的頂部
        layer.insertSublayer(myArcLayer, at: 0)

    }
    
    // MARK: 照片Image AutoLayout
    func setupPhotoImageView() {
        profilePhotoImageView.image = UIImage(named: "person")
        profilePhotoImageView.contentMode = .scaleAspectFill
        profilePhotoImageView.backgroundColor = .white
        addSubview(profilePhotoImageView)
        profilePhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profilePhotoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 70),
            profilePhotoImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: -78),
            profilePhotoImageView.heightAnchor.constraint(equalToConstant: 150),
            profilePhotoImageView.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        profilePhotoImageView.layer.borderColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 0.9).cgColor //UIColor.black.cgColor
        profilePhotoImageView.layer.borderWidth = 0.5

        // 圓半徑設為 寬的一半
        profilePhotoImageView.layer.cornerRadius = 75
        // 確保圓形圖不顯示超出邊界的部分
        profilePhotoImageView.clipsToBounds = true
        profilePhotoImageView.layer.masksToBounds = true        // MARK: 讓照片變成圓形的
    }
    
    // MARK: 照相Button AutoLayout
    func setupCameraBtn() {
        profileCameraBtn.setImage(UIImage(named: "camera"), for: .normal)
        addSubview(profileCameraBtn)
        profileCameraBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileCameraBtn.topAnchor.constraint(equalTo: profilePhotoImageView.bottomAnchor, constant: -26),
            profileCameraBtn.leadingAnchor.constraint(equalTo: profilePhotoImageView.trailingAnchor, constant: -28),
            profileCameraBtn.widthAnchor.constraint(equalToConstant: 30),
            profileCameraBtn.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    // MARK: 姓名Label AutoLayout
    func setupUserTitleLabel() {
        userTitleLabel.text = "姓名"
        userTitleLabel.textColor = .white
        addSubview(userTitleLabel)
        userTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userTitleLabel.topAnchor.constraint(equalTo: profilePhotoImageView.bottomAnchor, constant: 120),
            userTitleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            userTitleLabel.widthAnchor.constraint(equalToConstant: 50),
            userTitleLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // MARK: 儲存按鈕 AutoLayout
    func setupSaveProfileBtn() {
        saveProfileBtn.setTitle("儲存", for: .normal)
        addSubview(saveProfileBtn)
        saveProfileBtn.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        saveProfileBtn.layer.borderColor = UIColor(red: 186/255, green: 129/255, blue: 71/255, alpha: 1).cgColor
        saveProfileBtn.layer.borderWidth = 2.0
        saveProfileBtn.clipsToBounds = true
        saveProfileBtn.layer.cornerRadius = 8
        saveProfileBtn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20) // 调整上下左右内邊距
        saveProfileBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveProfileBtn.topAnchor.constraint(equalTo: profilePhotoImageView.bottomAnchor, constant: 120),
            saveProfileBtn.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            saveProfileBtn.widthAnchor.constraint(equalToConstant: 90),
            saveProfileBtn.heightAnchor.constraint(equalToConstant: 40),
        ])
        saveProfileBtn.addTarget(self, action: #selector(btnTouchDown), for: .touchDown)
        saveProfileBtn.addTarget(self, action: #selector(btnTouchUpInside), for: .touchUpInside)
    }
    
    @objc func btnTouchDown() {
        saveProfileBtn.backgroundColor = UIColor(red: 186/255, green: 129/255, blue: 71/255, alpha: 1)
    }
    
    @objc func btnTouchUpInside() {
        saveProfileBtn.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
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
