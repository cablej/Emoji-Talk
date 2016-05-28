//
//  CustomizeEmojiTableViewController.swift
//  Emoji Talk
//
//  Created by Jack Cable on 5/27/16.
//  Copyright © 2016 Uhack Emoji. All rights reserved.
//

import UIKit
import EmojiKit

class CustomizeEmojiTableViewController: UITableViewController {

    var emojiList : [Emoji] = []
    
    override func viewDidLoad() {
        EmojiTalkHelper.initializeAndReturnEmojis { (emojiList) in
            self.emojiList = emojiList
            dispatch_async(dispatch_get_main_queue(),{ //operate on main thread
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func onDoneButtonTapped(sender: AnyObject) {
        EmojiTalkHelper.writeEmojisToFile(emojiList)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSaveButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func onEditButtonTapped(sender: AnyObject) {
        tableView.setEditing(!tableView.editing, animated: true)
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let emojiToMove = emojiList[sourceIndexPath.row]
        emojiList.removeAtIndex(sourceIndexPath.row)
        emojiList.insert(emojiToMove, atIndex: destinationIndexPath.row)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        emojiList.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojiList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EmojiCell", forIndexPath: indexPath) as! EmojiTableViewCell
        let currentEmoji = emojiList[indexPath.row]
        cell.titleLabel.text = "\(currentEmoji.character) \(currentEmoji.name)"
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let nvc = segue.destinationViewController as? UINavigationController, let vc = nvc.viewControllers.first as? EditEmojiViewController {
            vc.emoji = emojiList[tableView.indexPathForSelectedRow!.row]
            
            NSNotificationCenter.defaultCenter().addObserver(
                self,
                selector: #selector(CustomizeEmojiTableViewController.emojiSaved(_:)),
                name: "saveEmojiNotification",
                object: nil)
        } else if let nvc = segue.destinationViewController as? UINavigationController, let _ = nvc.viewControllers.first as? AddEmojiTableTableViewController {
            NSNotificationCenter.defaultCenter().addObserver(
                self,
                selector: #selector(CustomizeEmojiTableViewController.emojiSaved(_:)),
                name: "saveEmojiNotification",
                object: nil)
        }
    }
    
    func emojiSaved(notification: NSNotification) {
        let name = notification.userInfo!["title"] as! String
        let character = notification.userInfo!["character"] as! String
        
        for emoji in emojiList {
            if(emoji.character == character) {
                emojiList[tableView.indexPathForSelectedRow!.row].name = name
                tableView.reloadData()
                NSNotificationCenter.defaultCenter().removeObserver(self, name: "saveEmojiNotification", object: nil)
                return
            }
        }
        
        // add new emoji
        emojiList.append(Emoji(name: name, character:character)!)
        
        tableView.reloadData()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "saveEmojiNotification", object: nil)
    }
    
}
