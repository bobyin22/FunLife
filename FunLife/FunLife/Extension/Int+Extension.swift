//
//  Int+Extension.swift
//  FunLife
//
//  Created by Yin Bob on 2025/9/12.
//

extension Int {
    func toTimeString() -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let secs = self % 60
        return String(format: "%02d:%02d:%02d", hours,
minutes, secs)
    }
}
