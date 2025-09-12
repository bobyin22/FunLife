//
//  AddTaskViewModel.swift
//  FunLife
//
//  Created by 尹周舶 on 9/9/25.
//

import Combine

final class AddTaskViewModel: ObservableObject {

    private let firebaseService: FirebaseServiceProtocol

    @Published var editingTaskText: String = "今日任務"
    @Published var shouldDismiss: Bool = false

    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }

    func saveTask(taskText: String) {
        firebaseService.createTask(taskText: taskText)
        self.editingTaskText = taskText
        shouldDismiss = true
    }
}
