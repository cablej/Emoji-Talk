//
//  AddEmojiTableTableViewController.swift
//  Emoji Talk
//
//  Created by Jack Cable on 5/28/16.
//  Copyright © 2016 Uhack Emoji. All rights reserved.
//

import UIKit
import EmojiKit

class AddEmojiTableTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    
    var allEmojis : [Emoji] = []
    
    let emojiFetcher = EmojiFetcher()
    
    var searchQuery = ""
    var DEFAULT_QUERY = "face"
    
    var hasNextStep = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        processQuery()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if(hasNextStep) {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchQuery = searchBar.text!
        processQuery()
    }
    
    @IBAction func onCancelButtontapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func processQuery() {
        emojiFetcher.query(searchQuery == "" ? DEFAULT_QUERY : searchQuery) { emojiResults in
            self.allEmojis = emojiResults
            dispatch_async(dispatch_get_main_queue(),{ //operate on main thread
                self.tableView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmojis.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EmojiCell", forIndexPath: indexPath) as! EmojiTableViewCell

        cell.titleLabel.text = allEmojis[indexPath.row].character

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let nvc = segue.destinationViewController as? UINavigationController, vc = nvc.viewControllers.first as? EditEmojiViewController {
            var emoji = allEmojis[tableView.indexPathForSelectedRow!.row]
            emoji.name = ""
            vc.emoji = emoji
            hasNextStep = true
            
            NSNotificationCenter.defaultCenter().addObserver(
                self,
                selector: #selector(AddEmojiTableTableViewController.doneEditing(_:)),
                name: "addEmojiNotification",
                object: nil)
        }
    }
 
    func doneEditing(notification: NSNotification) {
        dismissViewControllerAnimated(true, completion: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "addEmojiNotification", object: nil)
    }

}
