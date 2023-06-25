//
//  ProfileViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/25.
//

import UIKit
import FirebaseFirestore

class ProfileViewController: UIViewController {

    let profileView = ProfileView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileView()
    }
    
    // MARK: 把自定義的View設定邊界
    func setupProfileView() {
        view.addSubview(profileView)
        
        // 儲存按鈕可以點擊
        profileView.saveProfileBtn.addTarget(self, action: #selector(clickSaveProfileBtn), for: .touchUpInside)

        profileView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            profileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
    
    @objc func clickSaveProfileBtn() {
        modifyAPIName()
    }
    
    func modifyAPIName() {
        let db = Firestore.firestore()
        db.collection("users").document("\(UserDefaults.standard.string(forKey: "myUserID")!)").setData(["name": profileView.profileNameTextField.text]) { error in
            if let error = error {
                print("Document 建立失敗")
            } else {
                print("Document 建立成功")
            }
        }
    }
    
}
