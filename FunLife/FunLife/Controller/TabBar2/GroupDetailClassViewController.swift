//
//  GroupDetailClassViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/7/7.
//

import UIKit
import FirebaseFirestore
import Kingfisher

class GroupDetailClassViewController: UIViewController {

    let groupDetailClassView = GroupDetailClassView()           // 建立自定義View的實體當作變數
    let layout = UICollectionViewFlowLayout()                   // 建立 UICollectionViewFlowLayout
    var groupDetailClassCollectionView: UICollectionView!
    var classNameString: String = ""                            // 讓Label吃到上一頁傳來的教室名稱
    var fetchClassID = String()                                 // 接住上一頁GroupList傳來要進入的教室
    let firebaseManager = FirebaseManager()                     // 建立Manager的實體當作變數
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGroupDetailClassView()                                      // 呼叫畫出自定義View函式
        setupGroupDetailClassCollectionView()                            // 呼叫畫出自定義CollectionView函式
        firebaseManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("😎接到fetchClassID是", fetchClassID)
        firebaseManager.fetchIDAPI(parameterFetchClassID: fetchClassID)
        groupDetailClassView.groupDetailNameLabel.text = classNameString // 讓Label吃到上一頁傳來的教室名稱
    }
    
    // MARK: 畫出自定義View
    func setupGroupDetailClassView() {
        view.addSubview(groupDetailClassView)
        groupDetailClassView.backgroundColor = UIColor(red: 81/255, green: 88/255, blue: 104/255, alpha: 1)
        groupDetailClassView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupDetailClassView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            groupDetailClassView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            groupDetailClassView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            groupDetailClassView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        // MARK: 允許邀請按鈕點擊有反應
        groupDetailClassView.inviteGroupBtn.addTarget(self, action: #selector(clickInvite), for: .touchUpInside)
        
    }
    
    // MARK: 點擊邀請按鈕觸發 彈跳出UIActivityViewController
    @objc func clickInvite() {
        
        if UserDefaults.standard.string(forKey: "myGroupID") == nil {
            alertMsg()
        } else {
            guard let url = URL(string: "FunLife://\(UserDefaults.standard.string(forKey: "myGroupID")!)") else { return }
            let shareSheertVC = UIActivityViewController( activityItems: [url], applicationActivities: nil )
            present(shareSheertVC, animated: true)
        }
        
    }
    
    func alertMsg() {
        let alert = UIAlertController(title: "只有房主可以邀請人喔", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: 畫出自定義CollectionView
    func setupGroupDetailClassCollectionView() {
        // let layout = UICollectionViewFlowLayout()   // 建立 UICollectionViewFlowLayout
        // let groupDetailClassCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        let layout = UICollectionViewFlowLayout()
        groupDetailClassCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.addSubview(groupDetailClassCollectionView)
        groupDetailClassCollectionView.backgroundColor = UIColor(red: 81/255, green: 88/255, blue: 104/255, alpha: 1)   //.systemMint//
        groupDetailClassCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupDetailClassCollectionView.topAnchor.constraint(equalTo: groupDetailClassView.classWindowImgaeView.bottomAnchor, constant: 0),
            groupDetailClassCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            groupDetailClassCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            groupDetailClassCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        // 註冊 cell 以供後續重複使用
        groupDetailClassCollectionView.register(GroupDetailClassCollectionViewCell.self,forCellWithReuseIdentifier: "GroupDetailClassCollectionViewCell")

        // 註冊 section 的 header 跟 footer 以供後續重複使用
        // groupDetailClassCollectionView.register(UICollectionReusableView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
        // groupDetailClassCollectionView.register(UICollectionReusableView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")

        // 設置委任對象
        groupDetailClassCollectionView.delegate = self
        groupDetailClassCollectionView.dataSource = self
    }
}

// MARK: 接受要認做的事情
extension GroupDetailClassViewController: UICollectionViewDelegate {
    
}

// MARK: 顯示資料
extension GroupDetailClassViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        firebaseManager.classMembersNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupDetailClassCollectionViewCell",
                                                      for: indexPath) as? GroupDetailClassCollectionViewCell else {
            // 處理轉換失敗的情況，例如創建一個預設的 UITableViewCell
            return UICollectionViewCell()
        }
        
        // 姓名
        cell.personNameLabel.text = firebaseManager.classMembersIDDictionary[firebaseManager.classMembersIDArray[indexPath.row]]
        
        // 頭像        
        if let urlString = firebaseManager.classMembersImageDictionary[firebaseManager.classMembersIDArray[indexPath.row]],
            let url = URL(string: urlString) {
            cell.personIconBtn.kf.setImage(with: url, for: .normal)
        }

        // 時間
        if let time = firebaseManager.classMembersTimeDictionary[firebaseManager.classMembersIDArray[indexPath.row]] {
            
            let hours = Int(time) / 3600
            let minutes = (Int(time) % 3600) / 60
            let seconds = Int(time) % 60
            let formattedTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            cell.personTimerLabel.text = "\(formattedTime)"
            
        } else {
            cell.personTimerLabel.text = nil
        }
        
        print("1️⃣classMembersNameArray", firebaseManager.classMembersNameArray)
        print("2️⃣classMembersIDArray", firebaseManager.classMembersIDArray)
        print("📸classMembersImageArray", firebaseManager.classMembersImageArray)
        print("3️⃣classMembersTimeDictionary", firebaseManager.classMembersTimeDictionary)
        print("4️⃣classMembersIDDictionary", firebaseManager.classMembersIDDictionary)
        print("📸classMembersImageDictionary", firebaseManager.classMembersImageDictionary)
        
        return cell
    }
    
}

// MARK: 顯示Cell的各種距離
extension GroupDetailClassViewController: UICollectionViewDelegateFlowLayout {
    
    // item水平間距 min Interitem spacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { return 40 }
    
    // 格子與格子row間距 min line spacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat { return 140 }
    
    // collection格子與collection Header距離 (section垂直間距，section的inset，相當於是内容的margin)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        // return UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        if section == 0 {
            return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        } else {
            return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        }
    }
    
    // header的高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 10)
    }
}

extension GroupDetailClassViewController: FirebaseManagerDelegate {
    func renderText() {}
    
    func kfRenderImg() {}
    
    func reloadData() {
        self.groupDetailClassCollectionView.reloadData()
    }
}
