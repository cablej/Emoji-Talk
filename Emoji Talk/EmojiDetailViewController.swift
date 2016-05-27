//
//  EmojiDetailViewController.swift
//  Emoji Talk
//
//  Created by Jack Cable on 5/27/16.
//  Copyright © 2016 Uhack Emoji. All rights reserved.
//

import UIKit
import EmojiKit

class EmojiDetailViewController: UIViewController {
    
    var currentEmoji: Emoji?
    
    @IBOutlet var emojiLabel: UILabel!
    
    @IBAction func onBackButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("displaying emoji")
        print(currentEmoji)
        
        emojiLabel.text = currentEmoji?.character
    }
    
}
