//
//  ProfileViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/25.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import Kingfisher

class ProfileViewController: UIViewController {
    
    let profileView = ProfileView()
    let storage = Storage.storage().reference()
    var myUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileView()
        fetchMyImage()
        setupProfileVCNavBarColor()
    }
    
    func setupProfileVCNavBarColor() {
        let profileVCNavBarColorView = UIView()
        view.addSubview(profileVCNavBarColorView)
        profileVCNavBarColorView.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        profileVCNavBarColorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileVCNavBarColorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            profileVCNavBarColorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            profileVCNavBarColorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            profileVCNavBarColorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            //profileVCNavBarColorView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    // MARK: 一載入去users -> 個人ID -> image: "" 拿資料
    func fetchMyImage() {
        let db = Firestore.firestore()
        db.collection("users").document(UserDefaults.standard.string(forKey: "myUserID")!).getDocument() { snapshot, error in
             guard let snapshot = snapshot,
                   let data = snapshot.data() else { return }
            
            // 如果裡面有url載入
            // 如果沒有url，不做事
            if snapshot.data()!["image"] == nil {
                return
            } else {
                print("👻snapshot.data()!", snapshot.data()!["image"]!)

                if let imageUrlString = snapshot.data()?["image"] as? String,
                   let imageUrl = URL(string: imageUrlString) {
                    self.profileView.profilePhotoImageView.kf.setImage(with: imageUrl)
                }
            }

            if snapshot.data()!["name"] == nil {
                return
            } else {
                self.profileView.profileNameTextField.text = snapshot.data()?["name"]! as? String
            }
            
        }
    }
    
    // MARK: 把自定義的View設定邊界
    func setupProfileView() {
        view.addSubview(profileView)
        profileView.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        // 儲存按鈕可以點擊
        profileView.saveProfileBtn.addTarget(self, action: #selector(clickSaveProfileBtn), for: .touchUpInside)
        // 照片按鈕可以點擊
        profileView.profileCameraBtn.addTarget(self, action: #selector(clickCameraBtn), for: .touchUpInside)
        
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
                if action.title == "Camera" {                       // 如果選到是相機
                    
                    let myController = UIImagePickerController()    // 5️⃣建立實體
                    myController.sourceType = .camera
                    myController.delegate = self                    // 6️⃣當作是自己
                    self.present(myController, animated: true)
                    
                } else {                                            // 如果選到是相簿
                    
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
        modifyAPIName()     // 把名字打入cloud firestore database
        //profileView.saveProfileBtn.adjustsImageWhenHighlighted = true
    }
    
    
    // 把名字打入cloud firestore database
    func modifyAPIName() {
        let db = Firestore.firestore()
        db.collection("users").document("\(UserDefaults.standard.string(forKey: "myUserID")!)").updateData(["name": profileView.profileNameTextField.text]) { error in
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
        
        // 🍎 路徑 = 亂數 + .jpg
        func uploadPhoto(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
                let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
                if let data = image.jpegData(compressionQuality: 0.9) {
                    
                    fileReference.putData(data, metadata: nil) { result in
                        switch result {
                        case .success:
                             fileReference.downloadURL(completion: completion)
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
        }

        // 🍎 把選到照片傳上fire storage
        if let selectedImage = info[.originalImage] as? UIImage { didSelectPhoto(selectedImage) }
            picker.dismiss(animated: true, completion: nil)
        
        // 🍎 使用 UIImagePickerController 選擇照片後呼叫的方法
        func didSelectPhoto(_ photo: UIImage) {
            uploadPhoto(image: photo) { result in
                switch result {
                case .success(let url):
                    print("上傳成功，下載連結：\(url)")
                    self.myUrl = url.absoluteString
                    passUrlToUserFirebaseDataBase()
                case .failure(let error):
                    print("上傳失敗，錯誤訊息：\(error)")
                }
            }
        }

        // 🍀 取得相機拍下的照片  賦值給 我VC的UI照片元件
        profileView.profilePhotoImageView.image = info[.originalImage] as? UIImage
        
        // 🎃 把url傳到使用者
        func passUrlToUserFirebaseDataBase() {
            let db = Firestore.firestore()
            db.collection("users").document("\(UserDefaults.standard.string(forKey: "myUserID")!)").updateData(["image": myUrl]) { error in
                if let error = error {
                    print("Document 建立失敗")
                } else {
                    print("Document 建立成功")
                }
            }
        }
                
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 取消
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

/*
 1. 上傳image 檔案
 2. 拿到下載url
 3. 存url到 userDefault
 */
