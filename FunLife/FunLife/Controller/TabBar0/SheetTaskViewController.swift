//
//  SheetTaskViewController.swift
//  FunLife
//
//  Created by 尹周舶 on 2023/6/20.
//

import UIKit
import FirebaseFirestore

class SheetTaskViewController: UIViewController {

    let viewModel: SheetTaskViewModel
    let myTaskTableView = UITableView()
    //let firebaseManager = FirebaseManager()
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: SheetTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = SheetTaskViewModel(firebaseService: FirebaseManager())
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 186/255, green: 129/255, blue: 71/255, alpha: 1)
        myTaskTableView.register(SheetTaskTableViewCell.self, forCellReuseIdentifier: "SheetTaskTableViewCell")
        myTaskTableView.delegate = self
        myTaskTableView.dataSource = self
        setupTableView()

        viewModel.firebaseService.fetchTodayTasks()
        viewModel.$tasks
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.myTaskTableView.reloadData()
            }
            .store(in: &cancellables)
    }

    // MARK: 建立半截VC的tableView
    func setupTableView() {
        view.addSubview(myTaskTableView)
        myTaskTableView.backgroundColor = UIColor(red: 187/255, green: 129/255, blue: 72/255, alpha: 1)
        myTaskTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myTaskTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            myTaskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            myTaskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            myTaskTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
}

// MARK: 寫入自定義tableView的指派工作
extension SheetTaskViewController: UITableViewDelegate {
}

// MARK: 寫入自定義tableView的資料
extension SheetTaskViewController: UITableViewDataSource {

    // MARK: 幾個row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //firebaseManager.taskFirebaseArray.count
        viewModel.tasks.count
    }

    // MARK: 每個Cell內要顯示的資料
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SheetTaskTableViewCell", for: indexPath) as? SheetTaskTableViewCell
        else {
            // 處理轉換失敗的情況，例如創建一個預設的 UITableViewCell
            return UITableViewCell()
        }

        cell.settingInfo.text = viewModel.getTask(at: indexPath.row)
        cell.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        let rawTime = viewModel.getTaskTime(at: indexPath.row)
        cell.settingTime.text = Int(rawTime)?.toTimeString() ??
        "00:00:00"

        return cell
    }

    // MARK: 點選Cell執行的動作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectTask(at: indexPath.row)
        dismiss(animated: true, completion: nil)
    }

    // MARK: Row Deleting
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 若編輯模式為.delete --> 可執行刪除
        if editingStyle == .delete {
            firebaseManager.deleteTodayTask(deleteIndex: indexPath)
            // 執行刪除操作，例如從資料源中刪除對應的資料
            firebaseManager.taskFirebaseArray.remove(at: indexPath.row)         // indexPath.row --> 我們點擊的row
            firebaseManager.taskFirebaseTimeArray.remove(at: indexPath.row)     // indexPath.row --> 我們點擊的row
            tableView.deleteRows(at: [indexPath], with: .fade)                  // [indexPath]--> 我們點擊的row (ex.[(section0, row5)])
        }
    }
}

extension SheetTaskViewController: FirebaseManagerDelegate {

    func renderText() {}

    func kfRenderImg() {}

    // 實作 FirebaseManagerDelegate 協議的方法，當 FirebaseManager 完成任務獲取後，通知重新載入數據
    func reloadData() {
        self.myTaskTableView.reloadData()
    }

}
