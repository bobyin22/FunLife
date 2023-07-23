//
//  GroupDetailViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/24.
//

import UIKit
import FirebaseFirestore

class GroupDetailViewController: UIViewController {
    
    let groupDetailView = GroupDetailView()     // MARK: 生成自定義View的實體
    let groupDetailTableView = UITableView()    // MARK: UI 建立一個TableView

    var classNameString: String = ""            // 讓Label吃到上一頁傳來的教室名稱
    var classMembersIDArray: [String] = []      // 空陣列，要接住下方轉換成的 ["成員1ID", "成員2ID"]
    var classMembersNameArray: [String] = []    // 空陣列，要接住下方從 ["成員1ID", "成員2ID"] -> ["成員1Name", "成員2Name"]
    var classMembersTimeSum: Int = 0
    
    var classMembersIDDictionary: [String: String] = [:]   //
    var classMembersTimeDictionary: [String: Int] = [:]    //
    
    var indexNumber = 0                         // 獲取名字

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // view.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        fetchIDAPI()
        
        setupGroupDetailView()
        setupGroupDetailTableView()
        groupDetailTableView.register(GroupDetailTableViewCell.self, forCellReuseIdentifier: "GroupDetailTableViewCell")
        groupDetailTableView.delegate = self
        groupDetailTableView.dataSource = self
        
        groupDetailView.groupDetailNameLabel.text = classNameString // 讓Label吃到上一頁傳來的教室名稱
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: 把自定義的View設定邊界
    func setupGroupDetailView() {
        view.addSubview(groupDetailView)
        groupDetailView.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        groupDetailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            groupDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            groupDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            groupDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        // MARK: 允許邀請按鈕點擊有反應
        groupDetailView.inviteGroupBtn.addTarget(self, action: #selector(clickInvite), for: .touchUpInside)
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
    
    // MARK: 建立群組tablview的AutoLayout
    func setupGroupDetailTableView() {
        view.addSubview(groupDetailTableView)
        groupDetailTableView.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        groupDetailTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupDetailTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            groupDetailTableView.leadingAnchor.constraint(equalTo: groupDetailView.leadingAnchor, constant: 0),
            groupDetailTableView.trailingAnchor.constraint(equalTo: groupDetailView.trailingAnchor, constant: 0),
            groupDetailTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
        ])
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
                self.groupDetailTableView.reloadData()
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
                self.groupDetailTableView.reloadData()
            }
        }
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
                    self.groupDetailTableView.reloadData()
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
                self.groupDetailTableView.reloadData()
            }
            self.indexNumber += 1
        }
    }
    
}

// MARK: Delegate
extension GroupDetailViewController: UITableViewDelegate {
}

// MARK: DataSource
extension GroupDetailViewController: UITableViewDataSource {
    
    // 分组头即将要显示
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView,
                   forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.orange
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        // header.textLabel?.frame = header.frame
        header.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        header.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            header.contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            header.contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            header.contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            header.contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            // myTableView.heightAnchor.constraint(equalToConstant: 300)
        ])
        // header.textLabel?.backgroundColor = .blue
        header.textLabel?.textAlignment = .center
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "群組成員"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        classMembersNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupDetailTableViewCell", for: indexPath) as? GroupDetailTableViewCell
        else {
            // 處理轉換失敗的情況，例如創建一個預設的 UITableViewCell
            return UITableViewCell()
        }
        cell.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        
        // 頭像
        cell.personIconBtn.setImage(UIImage(named: "person1.png"), for: .normal)
        // 姓名
        cell.personNameLabel.text = classMembersIDDictionary[classMembersIDArray[indexPath.row]]
        // 時間
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
