//
//  MyGroupListViewController.swift
//  FunLife
//
//  Created by 尹周舶 on 2023/6/23.
//

import UIKit
import Combine

class MyGroupListViewController: UIViewController {
    
    let viewModel: MyGroupListViewModel
    private var cancellables = Set<AnyCancellable>()
    let groupListTableView = UITableView()
    let groupDetailClassVC = GroupDetailClassViewController()
    let selectedBackgroundView = UIView()
    
    required init?(coder: NSCoder) {
        let firebaseManager = FirebaseManager()
        self.viewModel = MyGroupListViewModel(firebaseService: firebaseManager)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGroupListTableView()
        setupAddGroupBtn()
        
        groupListTableView.register(MyGroupListTableViewCell.self, forCellReuseIdentifier: "MyGroupListTableViewCell")
        groupListTableView.delegate = self
        groupListTableView.dataSource = self
        navbarAndtabbarsetup()
        selectedBackgroundView.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 60/255, alpha: 1)
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetch()
    }
    
    func binding() {
        viewModel.$groupsName
            .sink { [weak self] groups in
                DispatchQueue.main.async {
                    self?.groupListTableView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldNavigateToDetail
            .sink { [weak self] navigationData in
                guard let data = navigationData else { return }
                self?.navigateToGroupDetail(groupName: data.groupName,
                                            groupID: data.groupID)
            }
            .store(in: &cancellables)
        
        viewModel.$shouldShowAlert
            .sink { [weak self] shouldShow in
                if shouldShow {
                    self?.alertMsg()
                    self?.viewModel.shouldShowAlert = false
                }
            }
            .store(in: &cancellables)
    }
    
    private func navigateToGroupDetail(groupName: String, groupID: String) {
        groupDetailClassVC.classNameString = groupName
        groupDetailClassVC.fetchClassID = groupID
        navigationController?.pushViewController(groupDetailClassVC, animated: true)
    }
    
    // MARK: 設定nav tab 底色與字顏色
    func navbarAndtabbarsetup() {
        // 設置 NavigationBar 的外觀
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    
        tabBarController?.tabBar.barTintColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
        tabBarController?.tabBar.shadowImage = UIImage()
        tabBarController?.tabBar.isTranslucent = false
    }
        
    // MARK: 建立UI TableView
    func setupGroupListTableView() {
        view.addSubview(groupListTableView)
        groupListTableView.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        groupListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupListTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),  // view.safeAreaLayoutGuide.topAnchor
            groupListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            groupListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            groupListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
        groupListTableView.separatorStyle = .none

    }
    // MARK: 建立UI 方形按鈕
    func setupAddGroupBtn() {
        let addGroupBtn = UIButton()
        addGroupBtn.setImage(UIImage(named: "plus.png"), for: .normal)
        view.addSubview(addGroupBtn)
        addGroupBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        
        addGroupBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addGroupBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            addGroupBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            addGroupBtn.heightAnchor.constraint(equalToConstant: 50),
            addGroupBtn.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: 點擊按鈕發生的事   建立群組頁
    @objc func clickBtn() {
        let createGroupVC = CreateGroupViewController()
        navigationController?.pushViewController(createGroupVC, animated: true)
    }
    
    // 提示框
    func alertMsg () {
        let alert = UIAlertController(title: "個人頁面資料不完整", message: "填上你的姓名、照片，讓好友知道你", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: 寫入要做的事
extension MyGroupListViewController: UITableViewDelegate {
    
}

// MARK: 寫入資料
extension MyGroupListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectGroup(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.groupsName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "MyGroupListTableViewCell",
                                                        for: indexPath) as? MyGroupListTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 38/255)
        cell.groupNameLabel.text = viewModel.groupsName[indexPath.row]
        cell.selectedBackgroundView = selectedBackgroundView
        return cell
    }
}
