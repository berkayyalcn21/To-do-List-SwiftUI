//
//  Models.swift
//  To do List
//
//  Created by Berkay on 14.07.2022.
//

import Foundation
import SwiftUI

struct PostModel: Decodable {
    let id: Int
    let content: String
    var isCompleted: Bool = false
}

