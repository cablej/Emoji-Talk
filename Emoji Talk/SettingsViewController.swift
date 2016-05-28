//
//  SettingsViewController.swift
//  Emoji Talk
//
//  Created by Jack Cable on 5/27/16.
//  Copyright © 2016 Uhack Emoji. All rights reserved.
//

import UIKit

extension NSUserDefaults {
    
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = dataForKey(key) {
            color = NSKeyedUnarchiver.unarchiveObjectWithData(colorData) as? UIColor
        }
        return color
    }
    
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedDataWithRootObject(color)
        }
        setObject(colorData, forKey: key)
    }
    
}

class SettingsViewController: UIViewController {
    
    @IBOutlet var buttonCollection: [UIButton]!
    
    @IBOutlet var customizeEmojiButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in buttonCollection {
            button.layer.cornerRadius = 15;
        }
        
        if let color = NSUserDefaults.standardUserDefaults().colorForKey("color") {
            customizeEmojiButton.backgroundColor = color
        }
    }
    
    @IBAction func onSetColorButtonTapped(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setColor(sender.backgroundColor, forKey: "color")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onDoneButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
