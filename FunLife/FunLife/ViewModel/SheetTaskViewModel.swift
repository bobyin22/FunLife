//
//  SheetTaskViewModel.swift
//  FunLife
//
//  Created by Yin Bob on 2025/9/12.
//

import Combine
import UIKit

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

    var taskCount: Int {
        firebaseService.taskFirebaseArray.count
    }

    func loadTasks() {
        firebaseService.fetchDayTasks() { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.tasks = self.firebaseService.taskFirebaseArray
                self.taskTimes = self.firebaseService.taskFirebaseTimeArray
            }
        }
    }

    func selectTask(at index: Int) {  // 不需要傳入 array
        selectedTask = firebaseService.taskFirebaseArray[index]
        selectedTime = Int(firebaseService.taskFirebaseTimeArray[index])?.toTimeString() ?? "00:00:00"
        shouldDismiss = true
    }

    func getTask(at index: Int) -> String {
        firebaseService.taskFirebaseArray[index]
    }

    func getTaskTime(at index: Int) -> String {
        let rawTime = firebaseService.taskFirebaseTimeArray[index]
        return Int(rawTime)?.toTimeString() ?? "00:00:00"
    }

    func deleteTask(at index: Int) {
        firebaseService.deleteTodayTask(deleteIndex: IndexPath(row: index, section:0))
        // 再更新本地數組
        tasks.remove(at: index)
        taskTimes.remove(at: index)
    }
}
