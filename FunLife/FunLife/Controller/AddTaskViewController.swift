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

class AddTaskViewController: UIViewController {
    
    let addTaskLabel = UILabel()
    let addTaskTextField = UITextField()
    let cancelTaskButton = UIButton()
    let saveTaskButton = UIButton()
    
    var titleTask = UILabel()   // 用來接住輸入的textField
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        setupAddTaskLabel()
        setupAddTaskTextField()
        setupCancelTaskButton()
        setupSaveTaskButton()
    }
    
    func setupAddTaskLabel() {
        view.addSubview(addTaskLabel)
        addTaskLabel.backgroundColor = .systemRed
        addTaskLabel.text = "標題"
        addTaskLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addTaskLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            addTaskLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addTaskLabel.heightAnchor.constraint(equalToConstant: 50),
            addTaskLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupAddTaskTextField() {
        view.addSubview(addTaskTextField)
        addTaskTextField.backgroundColor = .systemRed
        addTaskTextField.placeholder = "請輸入標題"
        // 輸入框的樣式 這邊選擇圓角樣式
        addTaskTextField.borderStyle = .roundedRect
        // 輸入框右邊顯示清除按鈕時機 這邊選擇當編輯時顯示
        addTaskTextField.clearButtonMode = .whileEditing
        addTaskTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addTaskTextField.topAnchor.constraint(equalTo: addTaskLabel.bottomAnchor, constant: 50),
            addTaskTextField.leadingAnchor.constraint(equalTo: addTaskLabel.leadingAnchor, constant: 0),
            addTaskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            addTaskTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupCancelTaskButton() {
        view.addSubview(cancelTaskButton)
        cancelTaskButton.setTitle("取消", for: .normal)
        cancelTaskButton.tintColor = .black
        cancelTaskButton.backgroundColor = .systemBlue
        cancelTaskButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelTaskButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -170),
            cancelTaskButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelTaskButton.heightAnchor.constraint(equalToConstant: 50),
            cancelTaskButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func setupSaveTaskButton() {
        view.addSubview(saveTaskButton)
        saveTaskButton.setTitle("儲存", for: .normal)
        saveTaskButton.tintColor = .black
        saveTaskButton.backgroundColor = .systemBlue
        saveTaskButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveTaskButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -170),
            saveTaskButton.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -170),
            saveTaskButton.heightAnchor.constraint(equalToConstant: 50),
            saveTaskButton.widthAnchor.constraint(equalToConstant: 150)
        ])
        saveTaskButton.addTarget(self, action: #selector(saveTaskToFirebase), for: .touchUpInside)
    }
    
    @objc func saveTaskToFirebase() {
        print("印出", addTaskTextField.text)
        createUser()
        
        titleTask.text = addTaskTextField.text  // 把輸入的TextField 給變數
    }
    
    func createUser() {
        let task = ["timer": "0", "user": "包伯"]
        let db = Firestore.firestore()                          // 拉出來不用在每個函式宣告
        
        let bobDocumentRef = db.collection("users").document("Bob")
        let nextTaskCollectionRef = bobDocumentRef.collection(addTaskTextField.text ?? "沒輸入")
        
        let today = Date()

        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
        let year = dateComponents.year!
        let month = dateComponents.month!
        let day = dateComponents.day!

        let weekday = Calendar.current.component(.weekday, from: today)
        let weekdayString = Calendar.current.weekdaySymbols[weekday - 1]

        // print("\(year).\(month).\(day).\(weekdayString)")
        
        // circleDateLabel.text = "\(year).\(month).\(day).\(weekdayString)" // "2023.06.13.Tue"
        
        nextTaskCollectionRef.document("\(month).\(day)").setData(task) { error in
            if let error = error {
                print("Error creating task: \(error)")
            } else {
                print("Task created successfully")
            }
        }
        
    }
}
