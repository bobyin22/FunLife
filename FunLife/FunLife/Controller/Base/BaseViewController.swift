//
//  BaseViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/15.
//

import UIKit

class BaseViewController: UIViewController {

    let circleView = UIView()
    let circleTimerLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemMint
        
        setupCircleUI()
    }
    
    func setupCircleUI() {
        
        view.addSubview(circleView)
        circleView.backgroundColor = .systemYellow
        circleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -200),
            circleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -150),
            circleView.heightAnchor.constraint(equalToConstant: 300),
            circleView.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        circleView.layer.borderColor = UIColor.black.cgColor
        circleView.layer.borderWidth = 2.0

        // 圓半徑設為 寬的一半
        circleView.layer.cornerRadius = 150
        // 確保圓形圖不顯示超出邊界的部分
        circleView.clipsToBounds = true
        circleView.layer.masksToBounds = false
    }
    
    func setupCircleTimer() {
        
    }
    
}
