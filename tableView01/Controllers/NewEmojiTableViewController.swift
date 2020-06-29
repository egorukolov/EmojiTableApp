//
//  NewEmojiTableViewController.swift
//  tableView01
//
//  Created by Egor Ukolov on 28.06.2020.
//  Copyright © 2020 Egor Ukolov. All rights reserved.
//

import UIKit

class NewEmojiTableViewController: UITableViewController {
    
    var emojiNew = Emoji(emoji: "", name: "", description: "", isFavorite: false)
    
    @IBOutlet var emojiTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
  
    @IBOutlet var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        updateSaveButton()
    }
    
    private func updateSaveButton() {
        let emojiText = emojiTextField.text ?? ""
        let nameText = nameTextField.text ?? ""
        let descriptionText = descriptionTextField.text ?? ""
        
        saveButton.isEnabled = !emojiText.isEmpty && !nameText.isEmpty && !descriptionText.isEmpty
    }
    
    private func updateUI() {
        emojiTextField.text = emojiNew.emoji
        nameTextField.text = emojiNew.name
        descriptionTextField.text = emojiNew.description
        
    }
    
    private func saveData() {
        
        let emoji = emojiTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        
        self.emojiNew = Emoji(emoji: emoji,
                           name: name,
                           description: description,
                           isFavorite: self.emojiNew.isFavorite)
        
        // сохранение данных в
        
        StorageManager.shared.saveEmoji(with: emojiNew)
        
        
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        
        updateSaveButton()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveSegue" else { return }
        
        saveData()
        
    }
    
}
