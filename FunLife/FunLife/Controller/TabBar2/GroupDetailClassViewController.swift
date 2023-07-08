//
//  GroupDetailClassViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/7/7.
//

import UIKit
import FirebaseFirestore

class GroupDetailClassViewController: UIViewController {

    let groupDetailClassView = GroupDetailClassView()   // 定義View建立一個變數
    let layout = UICollectionViewFlowLayout()   // 建立 UICollectionViewFlowLayout
    var groupDetailClassCollectionView: UICollectionView!
    var classNameString: String = ""            // 讓Label吃到上一頁傳來的教室名稱
    var classMembersIDArray: [String] = []      // 空陣列，要接住下方轉換成的 ["成員1ID", "成員2ID"]
    var classMembersNameArray: [String] = []    // 空陣列，要接住下方從 ["成員1ID", "成員2ID"] -> ["成員1Name", "成員2Name"]
    var classMembersTimeSum: Int = 0
    var classMembersIDDictionary: [String: String] = [:]   //
    var classMembersTimeDictionary: [String: Int] = [:]    //
    var indexNumber = 0                         // 獲取名字

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchIDAPI()
        view.backgroundColor = .white
        setupGroupDetailClassView()             // 呼叫畫出自定義View函式
        setupGroupDetailClassCollectionView()   // 呼叫畫出自定義CollectionView函式
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
    
    // MARK: 抓取firebase上 有member下的 userID (用自己的ID去 找有沒有這樣的document)
    // 拿到 ["成員1的ID", "成員2的ID"]
    func fetchIDAPI() {
        let db = Firestore.firestore()
        
        // MARK: 判斷式 如果UserDefault 有 FriendGroupID 用 FriendGroupID 去取得member
        // MARK:       如果          沒有               用 myGroupID     去取得member
        if UserDefaults.standard.string(forKey: "FriendGroupID") == nil {
            let documentRef = db.collection("group").document(UserDefaults.standard.string(forKey: "myGroupID")!).getDocument { snapshot, error in
                guard let snapshot = snapshot else { return }
                
                let memberNSArray = snapshot.data()!
                if let members = memberNSArray["members"] as? [String] {
                    self.classMembersIDArray = members
                }
                self.fetchTimeAPI()
                self.fetchNameAPI()                 // 去呼叫另外函式 轉拿 ["成員1的Name", "成員2的Name"]
                self.groupDetailClassCollectionView.reloadData()
            }
        } else {
            let documentRef = db.collection("group").document(UserDefaults.standard.string(forKey: "FriendGroupID")!).getDocument { snapshot, error in
                guard let snapshot = snapshot else { return }
                let memberNSArray = snapshot.data()!  // 這時候是一個NSArray
                if let members = memberNSArray["members"] as? [String] {  // 轉成Swift Array 拿到 ["成員1號ID", "成員2號ID"]
                    self.classMembersIDArray = members
                }
                self.fetchTimeAPI()                // 去呼叫另外函式 轉拿 ["成員1的Time", "成員2的Time"]
                self.fetchNameAPI()                // 去呼叫另外函式 轉拿 ["成員1的Name", "成員2的Name"]
                self.groupDetailClassCollectionView.reloadData()
            }
        }
    }
    
    // MARK: 畫出自定義CollectionView
    func setupGroupDetailClassCollectionView() {
        // let layout = UICollectionViewFlowLayout()   // 建立 UICollectionViewFlowLayout
        // let groupDetailClassCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        let layout = UICollectionViewFlowLayout()
        groupDetailClassCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.addSubview(groupDetailClassCollectionView)
        groupDetailClassCollectionView.backgroundColor = UIColor(red: 81/255, green: 88/255, blue: 104/255, alpha: 1)
        groupDetailClassCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupDetailClassCollectionView.topAnchor.constraint(equalTo: groupDetailClassView.classWindowImgaeView.bottomAnchor, constant: 10),
            groupDetailClassCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            groupDetailClassCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            groupDetailClassCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        // 註冊 cell 以供後續重複使用
        groupDetailClassCollectionView.register(GroupDetailClassCollectionViewCell.self,forCellWithReuseIdentifier: "GroupDetailClassCollectionViewCell")

        // 註冊 section 的 header 跟 footer 以供後續重複使用
        //groupDetailClassCollectionView.register(UICollectionReusableView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
        //groupDetailClassCollectionView.register(UICollectionReusableView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")

        // 設置委任對象
        groupDetailClassCollectionView.delegate = self
        groupDetailClassCollectionView.dataSource = self
    }
    
    // MARK: userID去拿當日的Timer
    func fetchTimeAPI() {
        var today = Date()
        var dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
        var month = dateComponents.month!
        let day = dateComponents.day! < 10 ? "0\(dateComponents.day!)" : "\(dateComponents.day!)"
        let db = Firestore.firestore()
        
        // MARK: 依據幾個member跑幾次
        for classMemberID in classMembersIDArray {
            let documentRef = db.collection("users").document(classMemberID).collection("\(month).\(day)").addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else { return }
                
                self.classMembersTimeSum = 0   // 換人時間歸零
                // MARK: 依據單一member，任務有幾個跑幾次
                for document in snapshot.documents {
                    guard let eachTaskTimer = document.data()["timer"] as? String else { return }    // 轉型成String
                    self.classMembersTimeSum += Int(eachTaskTimer)!
                }
                self.classMembersTimeDictionary[classMemberID] = self.classMembersTimeSum
                
                // MARK: 加完改變
                DispatchQueue.main.async {
                    self.groupDetailClassCollectionView.reloadData()
                }
                
            }
        }
    }
    
    // MARK: 拿userID陣列去 fetch抓 userName陣列
    // 拿到 ["成員1的Name", "成員2的Name"]
    func fetchNameAPI() {
        // 走2次
        for memberID in classMembersIDArray {
            let db = Firestore.firestore()
            db.collection("users").document("\(classMembersIDArray[indexNumber])").getDocument { snapshot, error in
                
                guard let snapshot = snapshot else { return }
                self.classMembersIDDictionary[memberID] = "\(snapshot.data()!["name"]!)"
                self.classMembersNameArray.append("\(snapshot.data()!["name"]!)")
                self.groupDetailClassCollectionView.reloadData()
            }
            self.indexNumber += 1
        }
    }
    
}

// MARK: 接受要認做的事情
extension GroupDetailClassViewController: UICollectionViewDelegate {
    
}

// MARK: 顯示資料
extension GroupDetailClassViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        classMembersNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupDetailClassCollectionViewCell",
                                                      for: indexPath) as? GroupDetailClassCollectionViewCell else {
            // 處理轉換失敗的情況，例如創建一個預設的 UITableViewCell
            return UICollectionViewCell()
        }
        
        //頭像
        cell.personIconBtn.setImage(UIImage(named: "person2.png"), for: .normal)
        //姓名
        cell.personNameLabel.text = classMembersIDDictionary[classMembersIDArray[indexPath.row]]
        //時間
        if let time = classMembersTimeDictionary[classMembersIDArray[indexPath.row]] {
            
            let hours = Int(time) / 3600
            let minutes = (Int(time) % 3600) / 60
            let seconds = Int(time) % 60
            let formattedTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            cell.personTimerLabel.text = "\(formattedTime)"
            // cell.personTimerLabel.text = "\(time)"
            
        } else {
            cell.personTimerLabel.text = nil
        }
        
        print("1️⃣classMembersNameArray", classMembersNameArray)
        print("2️⃣classMembersIDArray", classMembersIDArray)
        print("3️⃣classMembersTimeDictionary", classMembersTimeDictionary)
        print("4️⃣classMembersIDDictionary", classMembersIDDictionary)
        
        return cell
    }
    
}

// MARK: 顯示Cell的各種距離
extension GroupDetailClassViewController: UICollectionViewDelegateFlowLayout {
    
    // item水平間距 min Interitem spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if section == 0 {
            return 24
        } else {
            return 40
        }
    }
    
    // 格子與格子row間距 min line spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 130
    }
    
    // collection格子與collection Header距離 (section垂直間距，section的inset，相當於是内容的margin)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
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
