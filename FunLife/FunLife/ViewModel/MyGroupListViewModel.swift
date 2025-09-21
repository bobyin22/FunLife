//
//  MyGroupListViewModel.swift
//  FunLife
//
//  Created by Bob Yin on 9/20/25.
//

import Combine
import UIKit

class MyGroupListViewModel: ObservableObject {
    
    private let firebaseService: FirebaseServiceProtocol

    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }

    @Published var groupsName: [String] = []
    @Published var groupsID: [String] = []
    @Published var shouldNavigateToDetail: (groupName: String, groupID: String)?
    @Published var shouldShowAlert: Bool = false
    
    func fetch() {
        firebaseService.fetchGroupListAPI { [weak self] names, ids in
            DispatchQueue.main.async {
                self?.groupsName = names
                self?.groupsID = ids
            }
        }
    }
    
    func selectGroup(at index: Int) {
        let selectedGroupName = groupsName[index]
        let selectedGroupID = groupsID[index]
        
        firebaseService.checkUserHaveGroup { [weak self] isComplete  in
            DispatchQueue.main.async {
                if isComplete {
                    self?.shouldNavigateToDetail = (selectedGroupName, selectedGroupID)
                } else {
                    self?.shouldShowAlert = true
                }
            }
        }
    }
}
