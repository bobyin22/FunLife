//
//  ProfileViewController.swift
//  FunLife
//
//  Created by 尹周舶 on 2023/6/25.
//

import UIKit
import Combine
import Kingfisher

class ProfileViewController: UIViewController {

    let viewModel: ProfileViewModel
    private var cancellables = Set<AnyCancellable>()

    required init?(coder: NSCoder) {
        let firebaseManager = FirebaseManager()
        self.viewModel = ProfileViewModel(firebaseService: firebaseManager)
        super.init(coder: coder)
    }
    
    let profileView = ProfileView()
    let firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileView()
        viewModel.fetch()
        setupProfileVCNavBarColor()
        dataBinding()
    }

    func dataBinding() {
        viewModel.$profileImage
            .sink { [weak self] url in
                guard let self else { return }
                self.profileView.profilePhotoImageView.kf.setImage(with: url)
            }
            .store(in: &cancellables)

        viewModel.$profilename
            .sink { [weak self] name in
                guard let self else { return }
                self.profileView.profileNameTextField.text = name
            }
            .store(in: &cancellables)
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
        let name = profileView.profileNameTextField.text ?? ""
        viewModel.saveUserProfile(name)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 選到照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // 把選到照片傳上fire storage
        if let selectedImage = info[.originalImage] as? UIImage {
            // 立即顯示選中的照片
            profileView.profilePhotoImageView.image = selectedImage
            // 背景上傳並更新 URL
            viewModel.didSelectPhoto(selectedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 取消
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
