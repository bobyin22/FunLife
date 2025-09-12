//
//  AddTaskViewController.swift
//  FunLife
//
//  Created by 尹周舶 on 2023/6/16.
//

import UIKit
import IQKeyboardManager
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

protocol AddTaskViewControllerDelegate: AnyObject {
    func passTask(parameter: String)
    func passTaskStartTime(parameter: String)
}

class AddTaskViewController: UIViewController {
    let addTaskView = AddTaskView()
    var titleTaskLabel = UILabel()          // 用來接住輸入的textField，給HomeVC顯示用

    weak var delegate: AddTaskViewControllerDelegate?

    let viewModel: AddTaskViewModel
    private var cancellables = Set<AnyCancellable>()

    // 添加初始化方法
    init(viewModel: AddTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddTaskView()
        setupBinding()
    }

    // MARK: 切回Tab時顯示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addTaskView.addTaskTextField.text = ""
    }

    func setupBinding() {
        viewModel.$shouldDismiss
            .sink { [weak self] shouldDismiss in
                if shouldDismiss {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)
    }

    func setupAddTaskView() {
        view.addSubview(addTaskView)
        addTaskView.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        addTaskView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addTaskView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            addTaskView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            addTaskView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            addTaskView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
        addTaskView.cancelTaskButton.addTarget(self, action: #selector(cancelTaskToFirebase), for: .touchUpInside)
        addTaskView.saveTaskButton.addTarget(self, action: #selector(saveTaskToFirebase), for: .touchUpInside)
    }

    @objc func cancelTaskToFirebase() {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: UI儲存按鈕的objc要執行的事情(讓HomeVC知道新增任務)
    @objc func saveTaskToFirebase() {
        guard let taskText = addTaskView.addTaskTextField.text else { return } 
        viewModel.saveTask(taskText: taskText)
    }

}
