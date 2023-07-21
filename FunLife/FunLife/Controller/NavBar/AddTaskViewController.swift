//
//  AddTaskViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/16.
//

import UIKit
import IQKeyboardManager
import FirebaseFirestore
import FirebaseFirestoreSwift

// 1️⃣ 老闆定義要做的事
protocol AddTaskViewControllerDelegate: AnyObject {
    func passTask(parameter: String)
    func passTaskStartTime(parameter: String)
}

class AddTaskViewController: UIViewController {
    let addTaskView = AddTaskView()
    var titleTaskLabel = UILabel()          // MARK: 用來接住輸入的textField，給HomeVC顯示用
    
    // 2️⃣建立一個變數是自己
    weak var delegate: AddTaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // view.backgroundColor = .white
        setupAddTaskView()
    }
    
    // MARK: 切回Tab時顯示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addTaskView.addTaskTextField.text = ""
    }
    
    func setupAddTaskView() {
        view.addSubview(addTaskView)
        addTaskView.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        addTaskView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addTaskView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),    // view.safeAreaLayoutGuide.topAnchor
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
        
        // FirebaseManger負責這三行
        guard let taskText = addTaskView.addTaskTextField.text else { return }  // 吃到UI輸入的任務
        let firebaseManager = FirebaseManager()                                 // 產生Manager實體
        firebaseManager.createTask(taskText: taskText)  // 把輸入的任務傳給Manager，讓Manager上傳到雲端
        
        titleTaskLabel.text = addTaskView.addTaskTextField.text         // 把輸入的TextField 給變數
        print("titleTaskLabel.text", titleTaskLabel.text)
        self.navigationController?.popViewController(animated: true)    // 跳回上一頁，也就是HomeVC
        
        // 3️⃣使用的方法
        delegate?.passTask(parameter: addTaskView.addTaskTextField.text ?? "nil")
        delegate?.passTaskStartTime(parameter: "00.00.00")
    }
        
}
