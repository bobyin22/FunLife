//
//  SceneDelegate.swift
//  FunLife
//
//  Created by 尹周舶 on 2023/6/14.
//

import UIKit
import FirebaseFirestore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // swiftlint:disable line_length
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // swiftlint:disable unused_optional_binding
        guard let _ = (scene as? UIWindowScene) else { return }
        // swiftlint:enable unused_optional_binding
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    // swiftlint:enable line_length
    
    // MARK: 從別地方切換回這個App會呼叫
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print("SceneDelegate:","\(URLContexts)")
        
        if let url = URLContexts.first?.url {
            print("URL :", url)
            
            // 從 URL 中取得相關資訊
            if let scheme = url.scheme {
                print("URL Scheme:", scheme)
            }
            
            // 拿到生成的亂碼 舉例：5Qmy7teqRWTJdWjbtbLy
            if let host = url.host {
                print("URL Host:", host)
                
                // 把別人的GroupID存到UserDefault
                UserDefaults.standard.set(host, forKey: "FriendGroupID")      // 把亂數DocumentID 塞在 App的UserDefault裡
                
                // 拿groupID 去 group裡面，把自己userID加入到members
                let db = Firestore.firestore()
                let documentReference = db.collection("group").document("\(host)")
                documentReference.getDocument { document, error in
                    
                    guard let document,
                          document.exists,
                          var group = try? document.data(as: Group.self)
                    else {
                        return
                    }
                    
                    group.members.append("\(UserDefaults.standard.string(forKey: "myUserID")!)") //
                    
                    do {
                        // 把使用者ID加入到群組
                        try documentReference.setData(from: group)
                        // alert
                        if let rootViewController = self.window?.rootViewController {
                            let alert = UIAlertController(title: "恭喜加入群組成功",
                                                          message: "朋友已經在教室等你了喔",
                                                          preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
                                                          style: .default,
                                                          handler: { _ in
                                NSLog("The \"OK\" alert occured.")
                            }))
                            
                            rootViewController.present(alert, animated: true, completion: nil)
                        }
                        
                    } catch {
                        print(error)
                    }
                }
                
            }
            
        }
        
    }
    
}
