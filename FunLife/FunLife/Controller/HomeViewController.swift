//
//  HomeViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/15.
//

import UIKit

class HomeViewController: UIViewController {          //: BaseViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemOrange
        
        setNavigation()
    }
    
    // NavBar + 按鈕設置
    func setNavigation() {
        
        let settingSButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [settingSButton, addButton]
    }
}
