//
//  Models.swift
//  To do List
//
//  Created by Berkay on 14.07.2022.
//

import Foundation

// Models
struct PostModel: Decodable, Hashable {
    var id: Int
    let content: String
    var isCompleted: Bool
}


