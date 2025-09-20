//
//  ProfileViewModel.swift
//  FunLife
//
//  Created by Yin Bob on 2025/9/18.
//

import Combine
import UIKit

class ProfileViewModel: ObservableObject {
    
    private let firebaseService: FirebaseServiceProtocol

    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }

    @Published var profileImage: URL?
    @Published var profilename: String = ""

    func fetch() {
        firebaseService.fetchMyImage { [weak self] imageUrl, name in
            DispatchQueue.main.async {
                self?.profileImage = imageUrl
                self?.profilename = name
            }
        }
    }
    
    func saveUserProfile(_ name: String) {
        firebaseService.modifyUserName(name)
    }
    
    func didSelectPhoto(_ photo: UIImage) {
        firebaseService.uploadPhoto(image: photo) { result in
            switch result {
            case .success(let url):
                print("上傳成功，下載連結：\(url)")
                self.firebaseService.passUrlToUserFirebaseDataBase(myUrlString: url.absoluteString)
                
                // 更新 UI
                DispatchQueue.main.async {
                    self.profileImage = url
                }
                
            case .failure(let error):
                print("上傳失敗，錯誤訊息：\(error)")
            }
        }
    }
}
