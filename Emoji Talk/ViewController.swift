//
//  ViewController.swift
//  Emoji Talk
//
//  Created by Jack Cable on 5/27/16.
//  Copyright © 2016 Uhack Emoji. All rights reserved.
//

import UIKit
import EmojiKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var emojiCollectionView: UICollectionView!
    
    var emojiList : [Emoji] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetcher = EmojiFetcher()
        
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        
        fetcher.query("face") { emojiResults in
            /*for emoji in emojiResults {
                print("Current Emoji: \(emoji.character) \(emoji.name)")
            }*/
            self.emojiList = emojiResults
            dispatch_async(dispatch_get_main_queue(),{ //operate on main thread
                self.emojiCollectionView.reloadData()
            })
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = emojiCollectionView.dequeueReusableCellWithReuseIdentifier("EmojiCell", forIndexPath: indexPath) as! EmojiCell
        
        cell.emojiLabel.text = emojiList[indexPath.row].character
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

