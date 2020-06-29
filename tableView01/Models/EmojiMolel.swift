//
//  EmojiMolel.swift
//  tableView01
//
//  Created by Egor Ukolov on 25.06.2020.
//  Copyright © 2020 Egor Ukolov. All rights reserved.
//

import Foundation

struct Emoji: Codable {
    let emoji: String
    let name: String
    let description: String
    var isFavorite: Bool
}
