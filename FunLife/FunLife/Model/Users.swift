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

struct Users: Codable, Identifiable {
    @DocumentID var id: String?
    let user: String
    var timer: String
}
