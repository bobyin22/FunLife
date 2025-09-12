//
//  String+Extension.swift
//  FunLife
//
//  Created by Yin Bob on 2025/9/12.
//

extension String {
      func toTimeSeconds() -> Int {
          let components = self.split(separator: ":")
          guard components.count == 3,
                let hours = Int(components[0]),
                let minutes = Int(components[1]),
                let seconds = Int(components[2]) else {
              return 0
          }
          return hours * 3600 + minutes * 60 + seconds
      }
  }
