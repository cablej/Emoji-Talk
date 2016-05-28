//
//  EmojiDetailViewController.swift
//  Emoji Talk
//
//  Created by Jack Cable on 5/27/16.
//  Copyright © 2016 Uhack Emoji. All rights reserved.
//

import UIKit
import EmojiKit
import AVFoundation

class EmojiDetailViewController: UIViewController {
    
    var currentEmoji: Emoji?
    var synth = AVSpeechSynthesizer()
    
    @IBOutlet var emojiButton: UIButton!
    @IBOutlet var emojiNameLabel: UILabel!
    
    @IBAction func onBackButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emojiButton.setTitle(currentEmoji?.character, forState: UIControlState.Normal)
        emojiNameLabel.text = currentEmoji?.name
        
        speakEmoji()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let color = NSUserDefaults.standardUserDefaults().colorForKey("color") {
            view.backgroundColor = color
        }
    }
    
    @IBAction func onEmojiButtonTapped(sender: AnyObject) {
        speakEmoji()
    }
    
    func speakEmoji() {
        synth = AVSpeechSynthesizer()
        let myUtterance = AVSpeechUtterance(string: (currentEmoji?.name)!)
        myUtterance.rate = 0.4
        myUtterance.pitchMultiplier = 0.7
        synth.speakUtterance(myUtterance)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? SpellViewController {
            vc.currentEmoji = currentEmoji
        }
    }
    
}
