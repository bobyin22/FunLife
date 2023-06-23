//
//  CreateGroupViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/23.
//

import UIKit

class CreateGroupViewController: UIViewController {

    // MARK: 生成自定義View的實體
    let createGroupView = CreateGroupView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray2
        setupCreateGroupView()
    }
    
    // MARK: 把自定義的View設定邊界
    func setupCreateGroupView() {
        view.addSubview(createGroupView)
        createGroupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createGroupView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            createGroupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            createGroupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            // createGroupView.widthAnchor.constraint(equalToConstant: 300)
            // createGroupView.heightAnchor.constraint(equalToConstant: 500),
            createGroupView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
}
