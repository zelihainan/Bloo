//
//  Item.swift
//  Bloo
//
//  Created by Zeliha İnan on 7.07.2026.
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
