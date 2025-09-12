//
//  SheetTaskViewModel.swift
//  FunLife
//
//  Created by Yin Bob on 2025/9/12.
//

import Combine

class SheetTaskViewModel: ObservableObject {

    private let firebaseService: FirebaseServiceProtocol

    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }

    @Published var selectedTask: String = ""
    @Published var selectedTime: String = ""
    @Published var shouldDismiss: Bool = false
    @Published var tasks: [String] = []
    @Published var taskTimes: [String] = []

    func selectTask(at index: Int) {  // 不需要傳入 array
        selectedTask = firebaseService.taskFirebaseArray[index]
        selectedTime = Int(firebaseService.taskFirebaseTimeArray[index])?.toTimeString() ?? "00:00:00"
        shouldDismiss = true
    }

    var taskCount: Int {
        firebaseService.taskFirebaseArray.count
    }

    func getTask(at index: Int) -> String {
        firebaseService.taskFirebaseArray[index]
    }

    func getTaskTime(at index: Int) -> String {
        firebaseService.taskFirebaseTimeArray[index]
    }
}
