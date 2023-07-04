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
        
        weak var delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?
    }
    
    // MARK: 把自定義的View設定邊界
    func setupProfileView() {
        view.addSubview(profileView)
        
        // 儲存按鈕可以點擊
        profileView.saveProfileBtn.addTarget(self, action: #selector(clickSaveProfileBtn), for: .touchUpInside)
        // 照片按鈕可以點擊
        profileView.profileCaeraBtn.addTarget(self, action: #selector(clickCameraBtn), for: .touchUpInside)
        
        profileView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            profileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
    
    @objc func clickCameraBtn() {
        
        let controller = UIAlertController(title: "選擇開啟方式", message: nil, preferredStyle: .actionSheet)
        
        let names = ["Camera", "Album"]
        for name in names {
            let action = UIAlertAction(title: name, style: .default) { action in
                print(action.title)
                if action.title == "Camera" {
                    let myController = UIImagePickerController()    // 5️⃣建立實體
                    myController.sourceType = .camera
                    myController.delegate = self            // 6️⃣當作是自己
                    self.present(myController, animated: true)
                } else {
                    let myController = UIImagePickerController()    // 5️⃣建立實體
                    myController.sourceType = .photoLibrary
                    myController.delegate = self            // 6️⃣當作是自己
                    self.present(myController, animated: true)
                }
            }
            controller.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true)
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 選到照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("看起來照片有成功")
        profileView.profilePhotoImageView.image = info[.originalImage] as? UIImage
        // profileView.profilePhotoImageView.layer.masksToBounds = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 取消
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
}
