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
        createNewTask()
        titleTaskLabel.text = addTaskView.addTaskTextField.text  // 把輸入的TextField 給變數
        print("titleTaskLabel.text", titleTaskLabel.text)
        self.navigationController?.popViewController(animated: true)    // 跳回上一頁，也就是HomeVC
        
        // 3️⃣使用的方法
        delegate?.passTask(parameter: addTaskView.addTaskTextField.text ?? "nil")
        delegate?.passTaskStartTime(parameter: "00.00.00")
    }
    
    // MARK: 把新任務傳至firebase
    func createNewTask() {
        // MARK: 把日期功能補在這
        let today = Date()
        
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
        let year = dateComponents.year!
        let month = dateComponents.month!
        let day = dateComponents.day! < 10 ? "0\(dateComponents.day!)" : "\(dateComponents.day!)"   //如果小於10 加上0    大於10直接用
        
        let task = ["timer": "0", "user": "包伯"]
        let db = Firestore.firestore()                          // 拉出來不用在每個函式宣告
        
        let bobDocumentRef = db.collection("users").document("\(UserDefaults.standard.string(forKey: "myUserID")!)")
        
        let nextTaskCollectionRef = bobDocumentRef.collection("\(month).\(day)" ?? "沒輸入")
        nextTaskCollectionRef.document(addTaskView.addTaskTextField.text ?? "沒輸入").setData(task) { error in
            if let error = error {
                print("Error creating task: \(error)")
            } else {
                print("Task textField文字有成功存至cloud firebase")
            }
        }
        print("函式執行後", UserDefaults.standard.dictionaryRepresentation())
        
    }
}
