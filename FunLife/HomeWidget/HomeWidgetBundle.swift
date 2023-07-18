//
//  HomeWidgetBundle.swift
//  HomeWidget
//
//  Created by 邱慧珊 on 2023/7/18.
//

import WidgetKit
import SwiftUI

@main
struct HomeWidgetBundle: WidgetBundle {
    var body: some Widget {
        HomeWidget()
        HomeWidgetLiveActivity()
    }
}
