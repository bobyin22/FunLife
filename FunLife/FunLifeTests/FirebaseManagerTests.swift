//
//  FirebaseManagerTests.swift
//  FunLifeTests
//
//  Created by 邱慧珊 on 2023/7/23.
//

import XCTest
@testable import FunLife

final class FirebaseManagerTests: XCTestCase {

    // 測試Manager有沒有執行
    func testInitSuccess() {
        // Arrange
        let sut = FirebaseManager()
        
        // Action
        
        // Assert
        XCTAssertNotNil(sut)
    }
    
    // 測試值是不是nil
    func testCreateTaskIsNil() {
        // Arrange
        let sut = FirebaseManager()
        // Action
        let testTask = sut.createTask(taskText: "任務：冥想")
        // Assert
        // 夠正確地將這個任務傳送到 Firebase 資料庫中，並且不會返回 nil
        XCTAssertNotNil(testTask, "輸入的任務不會是nil")
    }
    
    // 測試值是不是字串
    func testCreateTaskIsString() {
        // Arrange
        let sut = FirebaseManager()
        // Action
        let testTask = sut.createTask(taskText: "任務：冥想")
        // Assert
        XCTAssertEqual(testTask, "任務：冥想")
    }
    
}
