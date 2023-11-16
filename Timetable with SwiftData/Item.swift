//
//  Item.swift
//  Timetable with SwiftData
//
//  Created by 細川泰智 on 2023/11/16.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
