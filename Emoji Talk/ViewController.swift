//
//  ViewController.swift
//  Emoji Talk
//
//  Created by Jack Cable on 5/27/16.
//  Copyright © 2016 Uhack Emoji. All rights reserved.
//

import UIKit
import EmojiKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {

    @IBOutlet var emojiCollectionView: UICollectionView!
    
    var emojiList : [Emoji] = []
    
    var searchQuery = ""
    var DEFAULT_QUERY = "face"
    
    @IBOutlet var searchTextField: UITextField!
    
    let fetcher = EmojiFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        
        searchTextField.delegate = self
        
        processQuery()
    }
    
    func processQuery() {
        fetcher.query(searchQuery == "" ? DEFAULT_QUERY : searchQuery) { emojiResults in
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }

    @IBAction func onSearchTextFieldEditingChanged(sender: AnyObject) {
        searchQuery = searchTextField.text!
        processQuery()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }

}

