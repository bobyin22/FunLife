//
//  HomeViewControllerTexts.swift
//  FunLifeTests
//
//  Created by 尹周舶 on 2023/7/23.
//

import XCTest
@testable import FunLife

final class HomeViewControllerTexts: XCTestCase {
    
    // 確認手機初始面向 會進到default case
    func testOrientationChanged() {
        
        // Given (Arrange)
        let sut = HomeViewController()
        
        // When (Act)
        let phoneSide = sut.orientationChanged()
        
        // Then (Assert)
        XCTAssertEqual(sut.oriString, "Unknown")   // 初始
    }

}
