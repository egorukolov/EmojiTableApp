//
//  StorageManager.swift
//  tableView01
//
//  Created by Egor Ukolov on 29.06.2020.
//  Copyright © 2020 Egor Ukolov. All rights reserved.
//

import Foundation

class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    private let emojiKey = "SavedEmoji"
    
    func saveEmoji(with emoji: Emoji) {
        var emojis = fetchEmoji()
        emojis.append(emoji)
        guard let data = try? JSONEncoder().encode(emojis) else { return }
        userDefaults.set(data, forKey: emojiKey)
    }
    
    func fetchEmoji() -> [Emoji] {
        guard let data = userDefaults.object(forKey: emojiKey) as? Data
            else { return [] }
        guard let emojis = try? JSONDecoder().decode([Emoji].self, from: data)
            else { return [] }
        return emojis
    }
    
    func deleteEmoji(at index: Int) {
        var emojis = fetchEmoji()
        emojis.remove(at: index)
        guard let data = try? JSONEncoder().encode(emojis) else { return }
        userDefaults.set(data, forKey: emojiKey)
    }
}
