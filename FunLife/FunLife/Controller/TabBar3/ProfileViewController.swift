//
//  ProfileViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/25.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    let profileView = ProfileView()
    let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileView()
        
        weak var delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?
        
        // 🍀
        guard let urlString = UserDefaults.standard.value(forKey: "myAvatarURL") as? String,
              let url = URL(string: urlString) else {
            return
        }

        // 🍀
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.profileView.profilePhotoImageView.image = image
            }
        })
        task.response   // 🍀
    }
    
    // MARK: 把自定義的View設定邊界
    func setupProfileView() {
        view.addSubview(profileView)
        profileView.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
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
    
    // 點擊相機按鈕
    @objc func clickCameraBtn() {
        let controller = UIAlertController(title: "選擇開啟方式", message: nil, preferredStyle: .actionSheet)
        let names = ["Camera", "Album"]
        
        // 顯示彈跳視窗 相機或是相簿
        for name in names {
            let action = UIAlertAction(title: name, style: .default) { action in
                // print(action.title)
                if action.title == "Camera" {                       //如果選到是相機
                    
                    let myController = UIImagePickerController()    // 5️⃣建立實體
                    myController.sourceType = .camera
                    myController.delegate = self                    // 6️⃣當作是自己
                    self.present(myController, animated: true)
                    
                } else {                                            //如果選到是相簿
                    
                    let myController = UIImagePickerController()    // 5️⃣建立實體
                    myController.sourceType = .photoLibrary
                    myController.delegate = self                    // 6️⃣當作是自己
                    self.present(myController, animated: true)
                    
                }
            }
            controller.addAction(action)
        }
        
        // 建立取消彈跳視窗
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true)
    }
    
    // 點擊儲存按鈕
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
        
        // 🍀取得相機拍下的照片
        profileView.profilePhotoImageView.image = info[.originalImage] as? UIImage
        
        // 🍀把照片轉成png檔
        guard let imageData = profileView.profilePhotoImageView.image?.pngData() else { return }
        
        // 🍀存入雲端路徑 images(資料夾)/file.png(檔案)
        storage.child("images/file.png").putData(imageData,
                                                 metadata: nil,
                                                 completion: { _, error in
            guard error == nil else {
                print("沒有上傳成功")
                return
            }
            
            self.storage.child("images/file.png").downloadURL(completion: { url, error in
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                UserDefaults.standard.set(urlString, forKey: "myAvatarURL")
                
                self.viewDidLoad()
//                // 🍀
//                guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
//                      let url = URL(string: urlString) else {
//                    return
//                }
//
//                // 🍀
//                let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
//                    guard let data = data, error == nil else {
//                        return
//                    }
//                    DispatchQueue.main.async {
//                        let image = UIImage(data: data)
//                        self.profileView.profilePhotoImageView.image = image
//                    }
//                })
//                task.response   // 🍀
                
                print("下載URL: \(urlString)")    // 印出firebase照片網址
                UserDefaults.standard.set(urlString, forKey: "url")
            })
        })
        
        picker.dismiss(animated: true, completion: nil)
    }
    // 取消
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
