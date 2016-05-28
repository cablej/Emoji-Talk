//
//  StoryViewController.swift
//  Emoji Talk
//
//  Created by Jack Cable on 5/28/16.
//  Copyright © 2016 Uhack Emoji. All rights reserved.
//

import UIKit
import EmojiKit
import AVFoundation

class StoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var storyTextView: UITextView!
    
    @IBOutlet var emojiCollectionView: UICollectionView!
    
    var emojiList : [Emoji] = []
    
    let fetcher = EmojiFetcher()
    
    var synth = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyTextView.becomeFirstResponder()
        
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSUserDefaults.standardUserDefaults().setObject(storyTextView.text, forKey: "story")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        synth = AVSpeechSynthesizer()
        let myUtterance = AVSpeechUtterance(string: "I want to tell you a story.")
        myUtterance.rate = 0.4
        myUtterance.pitchMultiplier = 0.7
        synth.speakUtterance(myUtterance)
        
        if let color = NSUserDefaults.standardUserDefaults().colorForKey("color") {
            view.backgroundColor = color
            emojiCollectionView.backgroundColor = color
        }
        
        EmojiTalkHelper.initializeAndReturnEmojis { (emojiList) in
            self.emojiList = emojiList
            dispatch_async(dispatch_get_main_queue(),{ //operate on main thread
                self.emojiCollectionView.reloadData()
            })
        }
        
        if let story = NSUserDefaults.standardUserDefaults().objectForKey("story") as? String {
            storyTextView.text = story
        }
    }

    @IBAction func onDoneButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = emojiCollectionView.dequeueReusableCellWithReuseIdentifier("EmojiCell", forIndexPath: indexPath) as! EmojiCell
        
        cell.emojiLabel.text = emojiList[indexPath.row].character
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        storyTextView.insertText(emojiList[indexPath.row].character)
    }
    
    @IBAction func onPlayButtonTapped(sender: AnyObject) {
        
        var storyText = storyTextView.text!
        
        for emoji in emojiList {
            storyText = storyText.stringByReplacingOccurrencesOfString(emoji.character, withString: " \(emoji.name) ")
        }
        
        synth = AVSpeechSynthesizer()
        let myUtterance = AVSpeechUtterance(string: storyText)
        myUtterance.rate = 0.4
        myUtterance.pitchMultiplier = 0.7
        synth.speakUtterance(myUtterance)
    }
    

}
