//
//  EditEmojiViewController.swift
//  Emoji Talk
//
//  Created by Jack Cable on 5/28/16.
//  Copyright © 2016 Uhack Emoji. All rights reserved.
//

import UIKit
import EmojiKit

class EditEmojiViewController: UIViewController {

    var emoji: Emoji?
    
    @IBOutlet var emojiLabel: UILabel!
    @IBOutlet var emojiTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        emojiLabel.text = emoji?.character
        emojiTextField.text = emoji!.name
        
        emojiTextField.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButtontapped(sender: AnyObject) {
        dismissViewControllerAnimated(true) {
            NSNotificationCenter.defaultCenter().postNotificationName("addEmojiNotification", object: nil)
        }
    }

    @IBAction func onSaveButtonTapped(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("saveEmojiNotification", object: nil, userInfo: ["title":emojiTextField.text!, "character": emojiLabel.text!])
        dismissViewControllerAnimated(true) {
            NSNotificationCenter.defaultCenter().postNotificationName("addEmojiNotification", object: nil)
        }
    }
}
