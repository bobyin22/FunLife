//
//  GroupDetailClassViewController.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/7/7.
//

import UIKit

class GroupDetailClassViewController: UIViewController {

    let groupDetailClassView = GroupDetailClassView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupGroupDetailClassView()
        setupGroupDetailClassCollectionView()
    }
    
    // MARK: 叫出自定義View
    func setupGroupDetailClassView() {
        view.addSubview(groupDetailClassView)
        groupDetailClassView.backgroundColor = UIColor(red: 81/255, green: 88/255, blue: 104/255, alpha: 1)
        groupDetailClassView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupDetailClassView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            groupDetailClassView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            groupDetailClassView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            groupDetailClassView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: 叫出自定義CollectionView
    func setupGroupDetailClassCollectionView() {
        let layout = UICollectionViewFlowLayout()   // 建立 UICollectionViewFlowLayout
        let groupDetailClassCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.addSubview(groupDetailClassCollectionView)
        // groupDetailClassCollectionView.backgroundColor = .systemGreen // UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        groupDetailClassCollectionView.backgroundColor = UIColor(red: 81/255, green: 88/255, blue: 104/255, alpha: 1)
        groupDetailClassCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupDetailClassCollectionView.topAnchor.constraint(equalTo: groupDetailClassView.classWindowImgaeView.bottomAnchor, constant: 10),
            groupDetailClassCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            groupDetailClassCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            groupDetailClassCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        // 註冊 cell 以供後續重複使用
        groupDetailClassCollectionView.register(GroupDetailClassCollectionViewCell.self,forCellWithReuseIdentifier: "GroupDetailClassCollectionViewCell")

        // 註冊 section 的 header 跟 footer 以供後續重複使用
        //groupDetailClassCollectionView.register(UICollectionReusableView.self,
                                                //forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                     //withReuseIdentifier: "Header")
        
        //groupDetailClassCollectionView.register(UICollectionReusableView.self,
                                                //forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                                     //withReuseIdentifier: "Footer")

        // 設置委任對象
        groupDetailClassCollectionView.delegate = self
        groupDetailClassCollectionView.dataSource = self
    }
    
}

extension GroupDetailClassViewController: UICollectionViewDelegate {
    
}

extension GroupDetailClassViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        17
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupDetailClassCollectionViewCell",
                                                      for: indexPath) as? GroupDetailClassCollectionViewCell else {
            // 處理轉換失敗的情況，例如創建一個預設的 UITableViewCell
            return UICollectionViewCell()
        }
        
        return cell
    }
    
}

extension GroupDetailClassViewController: UICollectionViewDelegateFlowLayout {
    // item水平間距
    // min Interitem spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if section == 0 {
            return 24
        } else {
            return 40
        }
    }
    
    // 格子與格子row間距
    // min line spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 130
    }
    
    // collection格子與collection Header距離
    // section垂直間距，section的inset，相當於是内容的margin
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        // return UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        if section == 0 {
            return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        } else {
            return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        }
    }
    
    // header的高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 10)
    }
}
