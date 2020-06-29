//
//  EmojiTableViewController.swift
//  tableView01
//
//  Created by Egor Ukolov on 25.06.2020.
//  Copyright © 2020 Egor Ukolov. All rights reserved.
//

import UIKit

class EmojiTableViewController: UITableViewController {

    var objects: [Emoji] = []
    
//    Example:
//    [
//    Emoji(emoji: "🥰", name: "Love", description: "Let's love each other", isFavorite: false),
//    Emoji(emoji: "😅", name: "Oops", description: "No one saw it", isFavorite: false),
//    Emoji(emoji: "😂", name: "Funny", description: "this is very funny", isFavorite: false)
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Emoji Raider"
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // recovery data from UserDefaults
        objects = StorageManager.shared.fetchEmoji()
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
        guard segue.identifier == "saveSegue" else { return }
        let sourceVC = segue.source as! NewEmojiTableViewController
        let emoji = sourceVC.emojiNew
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            objects[selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
            
        } else {
            let newIndexPath = IndexPath(row: objects.count, section: 0)
            objects.append(emoji)
            tableView.insertRows(at: [newIndexPath], with: .fade)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "editEmoji" else { return }
        let indexPath = tableView.indexPathForSelectedRow!
        let emoji = objects[indexPath.row]
        let navigationVC = segue.destination as! UINavigationController
        let newEmojiVC = navigationVC.topViewController as! NewEmojiTableViewController
        newEmojiVC.emojiNew = emoji
        newEmojiVC.title = "Edit"
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emojiCell", for: indexPath) as! EmojiTableViewCell
        let object = objects[indexPath.row]
        
        cell.set(object: object)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            StorageManager.shared.deleteEmoji(at: indexPath.row)
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath] , with: .fade )
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedEmoji = objects.remove(at: sourceIndexPath.row)
        objects.insert(movedEmoji, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)
        let favorite = favoriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done, favorite])
    }
    
    func doneAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Done") { (action, view, comlection) in
            self.objects.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            comlection(true)
        }
        action.backgroundColor = .systemGreen
        action.image = UIImage(systemName: "checkmark.circle")
        return action
    }
    
    func favoriteAction(at indexPath: IndexPath) -> UIContextualAction {
        var object = objects[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Favorite") { (action, view, comlection) in
            
            object.isFavorite = !object.isFavorite
            self.objects[indexPath.row] = object
            comlection(true)
        }
        action.backgroundColor = object.isFavorite ? .systemGroupedBackground : .systemGray
        action.image = UIImage(systemName: "heart")
        return action
    }
}
