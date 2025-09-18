//
//  SheetTaskViewController.swift
//  FunLife
//
//  Created by 尹周舶 on 2023/6/20.
//

import UIKit
import Combine

class SheetTaskViewController: UIViewController {

    let viewModel: SheetTaskViewModel
    let myTaskTableView = UITableView()
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: SheetTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 186/255, green: 129/255, blue: 71/255, alpha: 1)
        myTaskTableView.register(SheetTaskTableViewCell.self, forCellReuseIdentifier: "SheetTaskTableViewCell")
        myTaskTableView.delegate = self
        myTaskTableView.dataSource = self
        setupTableView()

        viewModel.loadTasks()

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
        cell.settingTime.text = viewModel.getTaskTime(at: indexPath.row)
        cell.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        return cell
    }

    // MARK: 點選Cell執行的動作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectTask(at: indexPath.row)
        dismiss(animated: true, completion: nil)
    }

    // MARK: Row Deleting
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteTask(at: indexPath.row)
        }
    }
}
