//
//  SpellViewController.swift
//  Emoji Talk
//
//  Created by Jack Cable on 5/27/16.
//  Copyright © 2016 Uhack Emoji. All rights reserved.
//

import UIKit
import EmojiKit
import AVFoundation

class SpellViewController: UIViewController {
    
    var currentEmoji: Emoji?
    var synth = AVSpeechSynthesizer()
    
    @IBOutlet var emojiButton: UIButton!
    //@IBOutlet var emojiNameLabel: UILabel!
    
    @IBOutlet var emojiNameLabel: UILabel!
    
    @IBOutlet var letterCollection: [UIButton]!
    
    @IBOutlet var deleteKey: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emojiButton.setTitle(currentEmoji?.character, forState: UIControlState.Normal)
        //emojiNameLabel.text = currentEmoji?.name
        
        emojiNameLabel.text = ""
        
        highlightNextLetter()
        
    }
    
    func highlightNextLetter() {
        for button in letterCollection {
            button.backgroundColor = UIColor.whiteColor()
        }
        
        let emojiName = currentEmoji!.name as NSString
        let currentText = emojiNameLabel.text! as NSString
        if(currentText.length < emojiName.length) {
            let emojiFirstCharacters = emojiName.substringWithRange(NSRange(location: 0, length: currentText.length))
            if emojiFirstCharacters.lowercaseString == currentText.lowercaseString { //highlight next letter
                if let button = findKey(String(emojiName.substringWithRange(NSRange(location: currentText.length, length: 1)))) {
                    button.backgroundColor = UIColor.greenColor()
                }
            } else { //highlight delete
                deleteKey.backgroundColor = UIColor.greenColor()
            }
        }
    }
    
    func findKey(letter: String) -> UIButton? {
        for button in letterCollection {
            if button.titleLabel!.text!.lowercaseString == letter.lowercaseString {
                return button
            }
        }
        return nil
    }
    
    @IBAction func onEmojiButtonTapped(sender: UIButton) {
        synth = AVSpeechSynthesizer()
        let myUtterance = AVSpeechUtterance(string: (currentEmoji?.name)!)
        myUtterance.rate = 0.3
        synth.speakUtterance(myUtterance)
    }
    
    @IBAction func onKeyboardButtonTapped(sender: UIButton) {
        emojiNameLabel.text = emojiNameLabel.text! + (sender.titleLabel?.text)!
        sender.backgroundColor = UIColor.whiteColor()
        
        highlightNextLetter()
    }
    
    @IBAction func onDeleteButtonTapped(sender: AnyObject) {
        let text = String(emojiNameLabel.text!.characters.dropLast())
        emojiNameLabel.text = text
        deleteKey.backgroundColor = UIColor.whiteColor()
        
        highlightNextLetter()
    }
    
    @IBAction func onDoneButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
