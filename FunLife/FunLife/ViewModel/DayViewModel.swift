//
//  DayViewModel.swift
//  FunLife
//
//  Created by Yin Bob on 2025/9/17.
//

import Combine
import UIKit

class DayViewModel: ObservableObject {

    private let firebaseService: FirebaseServiceProtocol

    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }

    @Published var tasks: [String] = []
    @Published var taskTimes: [String] = []

    var sumTime: Int {
        taskTimes.compactMap { Int($0) }.reduce(0, +)
    }

    var headTitle: String {
        let formattedTime = sumTime.toTimeString()
        return "本日專注累計\(formattedTime)"
    }

    var taskCount: Int {
        firebaseService.taskFirebaseArray.count
    }

    func fetch() {
        firebaseService.fetchDayTasks() { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.tasks = self.firebaseService.taskFirebaseArray
                self.taskTimes = self.firebaseService.taskFirebaseTimeArray
            }
        }
    }

    func getTask(at index: Int) -> String {
        firebaseService.taskFirebaseArray[index]
    }

    func getTaskTime(at index: Int) -> String {
        firebaseService.taskFirebaseTimeArray[index]
    }

    func selectDate(_ date: Date) {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        let day = dayFormatter.string(from: date)
        
        dayFormatter.dateFormat = "M"
        let month = dayFormatter.string(from: date)

        firebaseService.setSelectedDate(day: day, month: month)
        
        firebaseService.fetchDayTasks() { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.tasks = self.firebaseService.taskFirebaseArray
                self.taskTimes = self.firebaseService.taskFirebaseTimeArray
            }
        }
    }
}
