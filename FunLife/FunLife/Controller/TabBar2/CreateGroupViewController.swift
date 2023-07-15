//
//  CreateGroupViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/23.
//

import UIKit
import FirebaseFirestore

class CreateGroupViewController: UIViewController {
    
    // MARK: 生成自定義View的實體
    let createGroupView = CreateGroupView()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // view.backgroundColor = .white
        setupCreateGroupView()
        setupProfileVCNavBarColor()
    }
    
    func setupProfileVCNavBarColor() {
        let vcNavBarColorView = UIView()
        view.addSubview(vcNavBarColorView)
        vcNavBarColorView.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        vcNavBarColorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vcNavBarColorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            vcNavBarColorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            vcNavBarColorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            vcNavBarColorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            //vcNavBarColorView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    // MARK: 把自定義的View設定邊界
    func setupCreateGroupView() {
        view.addSubview(createGroupView)
        createGroupView.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        // 儲存按鈕可以點擊
        createGroupView.saveGroupBtn.addTarget(self, action: #selector(clickSaveGroupBtn), for: .touchUpInside)
        // 取消按鈕可以點擊
        createGroupView.cancelGroupBtn.addTarget(self, action: #selector(clickCancelGroupBtn), for: .touchUpInside)
        
        createGroupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createGroupView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            createGroupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            createGroupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            createGroupView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
    
    // 儲存按鈕 點擊動作 建立群組
    @objc func clickSaveGroupBtn() {
        
        // 取得輸入欄
        guard let cell = createGroupView.createGroupTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CreateGroupTableViewCell else { return }
        
        let newDocumentGroupID = db.collection("group").document()      // firebase建立一個亂數DocumentID
        let documentID = newDocumentGroupID.documentID                  // firebase建立一個亂數DocumentID 並賦值給變數
        UserDefaults.standard.set(documentID, forKey: "myGroupID")      // 把亂數DocumentID 塞在 App的UserDefault裡
        
        let task = ["groupID": "\(newDocumentGroupID.documentID)",
                    "founder": "\(UserDefaults.standard.string(forKey: "myUserID")!)",
                    "roomName": "\(cell.createGroupTextField.text!)",
                    "members": ["\(UserDefaults.standard.string(forKey: "myUserID")!)"],     // 把founder放入member中
        ] as [String : Any]
        
        // 把創立的群組資料傳到firebase
        db.collection("group").document("\(newDocumentGroupID.documentID)").setData(task) { error in
            if let error = error {
                print("Document 建立失敗")
            } else {
                print("Document 建立成功")
            }
        }
        self.navigationController?.popViewController(animated: true)    // MARK: 點擊按鈕發生的事   跳轉回群組List頁
    }
    
    // 取消按鈕 點擊動作
    @objc func clickCancelGroupBtn() {
        print("已取消")
        self.navigationController?.popViewController(animated: true)
    }
    
}
