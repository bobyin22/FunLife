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
        
        // MARK: 當把應用程式關掉，重開App載入個人頁面會抓取到剛剛傳上firebase的照片
        weak var delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?
        
        // 🍀去讀取我的UserDefault的myAvatarURL
        guard let urlString = UserDefaults.standard.value(forKey: "myAvatarURL") as? String,
              let url = URL(string: urlString) else {
            return
        }

        // 🍀讓照片變成image
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.profileView.profilePhotoImageView.image = image
            }
        })
        
        task.resume()   // 🍀
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
                if action.title == "Camera" {                       // 如果選到是相機
                    
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
        
        // 🍎
        var selectedImageFromPicker: UIImage?
        
        // 🍎取得從 UIImagePickerController 選擇的檔案
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = pickedImage
        }
        
        // 🍎可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
        let uniqueString = NSUUID().uuidString
        
        // 🍎當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
//        if let selectedImage = selectedImageFromPicker {
//
//            // 位置.UUID
//            let storageRef = Storage.storage().reference().child("AppCodaFireUpload").child("\(uniqueString).png")
//
//            if let uploadData = selectedImage.pngData() {
//
//                // 這行就是 FirebaseStorage 關鍵的存取方法。
//                storageRef.putData(uploadData,
//                                   metadata: StorageMetadata? = nil,
//                                   completion: { (data, error) in
//
//                    if error != nil {
//                        print("Error: \(error!.localizedDescription)")  // 若有接收到錯誤，我們就直接印在 Console 就好，在這邊就不另外做處理。
//                        return
//                    }
//
//                    // 連結取得方式就是：data?.downloadURL()?.absoluteString。
//                    if let uploadImageUrl = data?.downloadURL()?.absoluteString {
//                        print("Photo Url: \(uploadImageUrl)")   // 我們可以 print 出來看看這個連結事不是我們剛剛所上傳的照片。
//                    }
//                })
//            }
//        }
        
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

//        let uiImage = UIImage(named: "peter")
//        uploadPhoto(image: uiImage!) { result in
//            switch result {
//            case .success(let url):
//               print(url)
//            case .failure(let error):
//               print(error)
//            }
//        }
        if let selectedImage = info[.originalImage] as? UIImage {
                didSelectPhoto(selectedImage)
            }
            picker.dismiss(animated: true, completion: nil)
        
        // 使用 UIImagePickerController 選擇照片後呼叫的方法
        func didSelectPhoto(_ photo: UIImage) {
            uploadPhoto(image: photo) { result in
                switch result {
                case .success(let url):
                    print("上傳成功，下載連結：\(url)")
                case .failure(let error):
                    print("上傳失敗，錯誤訊息：\(error)")
                }
            }
        }

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


/*
 1. 上傳image 檔案
 2. 拿到下載url
 3. 存url到 userDefault
 */
