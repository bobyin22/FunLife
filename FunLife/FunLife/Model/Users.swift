//
//  Users.swift
//  FunLife
//
//  Created by 邱慧珊 on 2023/6/16.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift
// import FirebaseFirestore
// import FirebaseStorage
// import FirebaseAuth


// MARK: 自定義類別 在建立任務時會顯示
struct Users: Codable, Identifiable {
    @DocumentID var id: String?
    let user: String
    var timer: String
}
