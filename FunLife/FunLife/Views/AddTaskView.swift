//
//  AddTaskView.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/7/7.
//

import UIKit

class AddTaskView: UIView {
    
    // MARK: UI標題
    let addTaskLabel: UILabel = {
        let addTaskLabel = UILabel()
        return addTaskLabel
    }()
    
    // MARK: UI輸入欄
    let addTaskTextField: UITextField = {
        let addTaskTextField = UITextField()
        return addTaskTextField
    }()
    
    // MARK: UI取消按鈕
    let cancelTaskButton: UIButton = {
        let cancelTaskButton = UIButton()
        return cancelTaskButton
    }()
    
    // MARK: UI儲存按鈕
    let saveTaskButton: UIButton = {
        let saveTaskButton = UIButton()
        return saveTaskButton
    }()
    
    // MARK: 初始init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAddTaskLabel()
        setupAddTaskTextField()
        setupCancelTaskButton()
        setupSaveTaskButton()
    }
    
    // MARK: UI標題
    func setupAddTaskLabel() {
        addSubview(addTaskLabel)
        addTaskLabel.text = "新增任務"
        addTaskLabel.textColor = .white
        addTaskLabel.font = UIFont(name: "Helvetica", size: 20)
        addTaskLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addTaskLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            addTaskLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addTaskLabel.heightAnchor.constraint(equalToConstant: 50),
            addTaskLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // MARK: UI輸入欄
    func setupAddTaskTextField() {
        addSubview(addTaskTextField)
        addTaskTextField.backgroundColor = .systemGray2
        addTaskTextField.placeholder = "請輸入標題"
        // 輸入框的樣式 這邊選擇圓角樣式
        addTaskTextField.borderStyle = .roundedRect
        // 輸入框右邊顯示清除按鈕時機 這邊選擇當編輯時顯示
        addTaskTextField.clearButtonMode = .whileEditing
        addTaskTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addTaskTextField.topAnchor.constraint(equalTo: addTaskLabel.bottomAnchor, constant: 10),
            addTaskTextField.leadingAnchor.constraint(equalTo: addTaskLabel.leadingAnchor, constant: 0),
            addTaskTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addTaskTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: UI取消按鈕
    func setupCancelTaskButton() {
        addSubview(cancelTaskButton)
        cancelTaskButton.setTitle("取消", for: .normal)
        cancelTaskButton.tintColor = .black
        cancelTaskButton.backgroundColor = UIColor(red: 186/255, green: 129/255, blue: 71/255, alpha: 1)
        cancelTaskButton.clipsToBounds = true
        cancelTaskButton.layer.cornerRadius = 8
        cancelTaskButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20) // 调整上下左右内边距
        cancelTaskButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelTaskButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -80),
            cancelTaskButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelTaskButton.heightAnchor.constraint(equalToConstant: 50),
            cancelTaskButton.widthAnchor.constraint(equalToConstant: 150)
        ])
        
    }
    
    // MARK: UI儲存按鈕
    func setupSaveTaskButton() {
        addSubview(saveTaskButton)
        saveTaskButton.setTitle("儲存", for: .normal)
        saveTaskButton.tintColor = .black
        saveTaskButton.backgroundColor = UIColor(red: 186/255, green: 129/255, blue: 71/255, alpha: 1)
        saveTaskButton.clipsToBounds = true
        saveTaskButton.layer.cornerRadius = 8
        saveTaskButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20) // 调整上下左右内边距
        saveTaskButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveTaskButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -80),
            saveTaskButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -170),
            saveTaskButton.heightAnchor.constraint(equalToConstant: 50),
            saveTaskButton.widthAnchor.constraint(equalToConstant: 150)
        ])
        
    }

    // MARK: 需要寫上
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
