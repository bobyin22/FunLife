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
    let firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileView()
        firebaseManager.fetchMyImage()
        setupProfileVCNavBarColor()
        firebaseManager.delegate = self
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
        ])
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
                if action.title == "Camera" {                       // 如果選到是相機
                    let myController = UIImagePickerController()
                    myController.sourceType = .camera
                    myController.delegate = self
                    self.present(myController, animated: true)
                } else {                                            // 如果選到是相簿
                    let myController = UIImagePickerController()
                    myController.sourceType = .photoLibrary
                    myController.delegate = self
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
        firebaseManager.modifyAPIName(paramaterUserName: profileView.profileNameTextField.text ?? "nil")     // 把名字打入cloud firestore database
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 選到照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // 路徑 = 亂數 + .jpg
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

        // 把選到照片傳上fire storage
        if let selectedImage = info[.originalImage] as? UIImage { didSelectPhoto(selectedImage) }
            picker.dismiss(animated: true, completion: nil)
        
        // 使用 UIImagePickerController 選擇照片後呼叫的方法
        func didSelectPhoto(_ photo: UIImage) {
            uploadPhoto(image: photo) { result in
                switch result {
                case .success(let url):
                    print("上傳成功，下載連結：\(url)")
                    self.myUrl = url.absoluteString
                    self.firebaseManager.passUrlToUserFirebaseDataBase(myUrlString: self.myUrl)
                case .failure(let error):
                    print("上傳失敗，錯誤訊息：\(error)")
                }
            }
        }

        // 取得相機拍下的照片  賦值給 我VC的UI照片元件
        profileView.profilePhotoImageView.image = info[.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 取消
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


extension ProfileViewController: FirebaseManagerDelegate {
    
    func reloadData() {}
    
    func kfRenderImg() {
        self.profileView.profilePhotoImageView.kf.setImage(with: firebaseManager.profileVCImageUrl)  // imageUrl
    }
    
    func renderText() {
        self.profileView.profileNameTextField.text = firebaseManager.profileVCPassString
    }
    
}
