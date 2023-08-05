//
//  Users.swift
//  FunLife
//
//  Created by 尹周舶 on 2023/6/16.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift

// MARK: 自定義類別 在建立任務時會顯示
struct Users: Codable, Identifiable {
    @DocumentID var id: String?
    let user: String
    var timer: String
}

struct Group: Codable, Identifiable {
    @DocumentID var id: String?
    let founder: String
    let groupID: String
    let roomName: String
    var members: [String]
}

